import Std
import Blockfrost.Env
import Blockfrost.Models.Models
import Blockfrost.Typed.Typed
import Examples.Tui

open Std
open Blockfrost
open Blockfrost.Models
open Blockfrost.Typed

namespace Examples.ForwardScan
/-- Toggle this to true if you want raw console logs again. -/
def enableStdoutLogs : Bool := false

@[inline] def log (msg : String) : BF Unit :=
  if enableStdoutLogs then IO.println msg else pure ()

/-- Simple running counters for visibility. -/
structure Stats where
  blocksProcessed   : Nat := 0
  txsProcessed      : Nat := 0
  scriptsSeenUnique : Nat := 0
  scriptsFetched    : Nat := 0
  scriptsSkipped    : Nat := 0
deriving Repr

/-- Pretty one-liner for current totals. -/
def Stats.pp (s : Stats) : String :=
  s!"[totals] blocks={s.blocksProcessed} txs={s.txsProcessed} scripts(unique={s.scriptsSeenUnique} fetched={s.scriptsFetched} skipped={s.scriptsSkipped})"

/-- Write helper (swap with your DB if needed). -/
def writeText (path txt : String) : IO Unit := do
  IO.FS.createDirAll (System.FilePath.mk path |>.parent.getD ".")
  let h ← IO.FS.Handle.mk path IO.FS.Mode.write
  h.putStr txt; h.flush

@[inline] def liftIOBF {α} (io : IO α) : BF α :=
  fun _ => io

/-- Fetch CBOR for a script hash, decode it to UPLC via Aiken, and store the UPLC.
    Returns `true` iff we fetched+decoded (i.e., this hash was new and decode succeeded). -/
def fetchUplcIfNew
    (outDir : String)
    (seen   : IO.Ref (HashSet String))
    (stats  : IO.Ref Stats)
    (hash   : String)
    : BF Bool := do
  let s ← seen.get
  if s.contains hash then
    stats.modify fun st => { st with scriptsSkipped := st.scriptsSkipped + 1 }
    log s!"[script] {hash} -> skip (already seen)"
    return false

  let r ← scripts.cbor hash
  match r with
  | .error e =>
      log s!"[script] {hash} -> ERROR {e.status_code} {e.message}"
      return false
  | .ok sc =>
      match sc.cbor? with
      | none =>
          log s!"[script] {hash} -> no CBOR in response"
          return false
      | some cborHex =>
          let cborPath := s!"{outDir}/{hash}.cbor"
          let uplcPath := s!"{outDir}/{hash}.uplc"
          log s!"[script] {hash} -> decoding CBOR→UPLC via Aiken…"
          -- write CBOR hex to a file
          _ ← liftIOBF <| writeText cborPath cborHex
          -- run aiken with shell redirection to write the UPLC file
          let out ← liftIOBF <|
            IO.Process.output {
              cmd  := "sh"
              args := #["-c", s!"aiken uplc decode {cborPath} --cbor --hex > {uplcPath}"]
            }
          if out.exitCode != 0 then
            log s!"[script] {hash} -> Aiken decode FAILED (exit {out.exitCode})"
            if out.stderr.trim ≠ "" then
              log s!"stderr: {out.stderr.trim}"
            return false

          -- success: mark seen and bump stats
          seen.modify (·.insert hash)
          stats.modify fun st =>
            { st with
              scriptsFetched    := st.scriptsFetched + 1
              scriptsSeenUnique := st.scriptsSeenUnique + 1
            }
          log s!"[script] {hash} -> UPLC stored at {uplcPath}"
          -- delete the CBOR to keep folder clean
          _ ← liftIOBF <| IO.FS.removeFile cborPath
          return true

/-- Collect all script hashes “touched” by a tx:
    - scripts with redeemers (spending/minting/reward): txs.redeemers.script_hash
    - reference scripts on inputs/outputs: txs.utxos.reference_script_hash? -/
def scriptsInTx (txHash : String) : BF (List String) := do
  let rdsE ← txs.redeemers txHash
  let utxE ← txs.utxos txHash
  let mut acc : List String := []
  match rdsE with
  | .ok rds   => acc := rds.map (·.script_hash) ++ acc
  | .error _  => pure ()
  match utxE with
  | .ok u =>
      let fromInputs  := u.inputs  |>.filterMap (·.reference_script_hash?)
      let fromOutputs := u.outputs |>.filterMap (·.reference_script_hash?)
      acc := (fromInputs ++ fromOutputs) ++ acc
  | .error _ => pure ()
  return acc.eraseDups

def processTx (bus : Examples.Tui.Bus) (outDir : String)
    (seen : IO.Ref (HashSet String)) (stats : IO.Ref Stats) (txHash : String)
    : BF (Bool × Nat) := do
  let shs ← scriptsInTx txHash
  stats.modify fun st => { st with txsProcessed := st.txsProcessed + 1 }
  let mut anyBad := false
  let mut newCnt := 0
  for h in shs do
    let ok := Examples.Tui.parityOk h
    if !ok then anyBad := true
    let fetched ← fetchUplcIfNew outDir seen stats h
    if fetched then
      newCnt := newCnt + 1
      liftIOBF <| Examples.Tui.onNewScript bus h
  return (anyBad, newCnt)

def processBlock (bus : Examples.Tui.Bus) (outDir : String)
    (seen : IO.Ref (HashSet String)) (stats : IO.Ref Stats) (blockHash : String)
    : BF Unit := do
  -- show the block immediately (yellow = pending)
  match ← blocks.byHash blockHash with
  | .ok b    => liftIOBF <| Examples.Tui.onNewBlock bus b.hash b.height?
  | .error _ => liftIOBF <| Examples.Tui.onNewBlock bus blockHash none

  -- scan txs
  match ← blocks.txs blockHash with
  | .error _ => liftIOBF <| Examples.Tui.markBlockVerdict bus blockHash false
  | .ok ts   =>
      stats.modify fun st => { st with blocksProcessed := st.blocksProcessed + 1 }
      let mut bad := false
      for t in ts do
        let (b, _) ← processTx bus outDir seen stats t
        if b then bad := true
      -- finalize color: red if any fail, green otherwise (even with 0 new scripts)
      liftIOBF <| Examples.Tui.markBlockVerdict bus blockHash bad


/-- Walk forward from `fromHash` using `blocks.next` until we’ve reached `tipHash`.
    Returns the last processed block hash (or `fromHash` if nothing to do). -/
partial def catchUpToTip
    (bus    : Examples.Tui.Bus)
    (outDir : String)
    (seen   : IO.Ref (HashSet String))
    (stats  : IO.Ref Stats)
    (fromHash tipHash : String)
    : BF String := do
  if fromHash == tipHash then
    return fromHash
  let pageE ← blocks.next fromHash
  match pageE with
  | .error e =>
      log s!"[next] from={fromHash} ERROR {e.status_code} {e.message}"
      return fromHash
  | .ok page =>
      if page.isEmpty then
        log s!"[next] empty page after {fromHash}; processing tip {tipHash} directly"
        processBlock bus outDir seen stats tipHash
        return tipHash
      else
        let mut last := fromHash
        for b in page do
          match b.height? with
          | none => log s!"[catch-up] processing block {b.hash} (height unknown)"
          | some height => log s!"[catch-up] processing block {b.hash} (height {height})"
          processBlock bus outDir seen stats b.hash
          last := b.hash
          if b.hash == tipHash then
            return last
        catchUpToTip bus outDir seen stats last tipHash

/-- 10s polling loop: if a new block appears, process blocks forward to the tip.
    Keeps a `HashSet` to avoid re-fetching script CBOR forever. -/
partial def loop
    (bus    : Examples.Tui.Bus)
    (outDir : String)
    (state  : IO.Ref (Option String))  -- last processed block hash
    (seen   : IO.Ref (HashSet String)) -- processed script hashes
    (stats  : IO.Ref Stats)
    : BF Unit := do
  let latestE ← blocks.latest
  match latestE with
  | .error e =>
      log s!"[latest] ERROR {e.status_code} {e.message}"
  | .ok tip =>
      let last? ← state.get
      match last? with
      | none =>
          match tip.height? with
          | none => log s!"[loop] no last block; processing tip {tip.hash} (height unknown)"
          | some height => log s!"[loop] no last block; processing tip {tip.hash} (height {height})"
          processBlock bus outDir seen stats tip.hash
          state.set (some tip.hash)
      | some lastHash =>
          log s!"[loop] last={lastHash} tip={tip.hash}"
          if lastHash == tip.hash then
            log "[loop] no new blocks; waiting…"
          else
            log s!"[loop] new block(s) detected; catching up from {lastHash} -> {tip.hash}"
            let newLast ← catchUpToTip bus outDir seen stats lastHash tip.hash
            state.set (some newLast)
  IO.sleep (10 * 1000) -- 10s
  loop bus outDir state seen stats

end Examples.ForwardScan

/-- Example entry point. -/
def main : IO Unit := do
  let some pid ← IO.getEnv "BLOCKFROST_PROJECT_ID"
    | throw <| IO.userError "Set BLOCKFROST_PROJECT_ID"
  let env : Env := { base := "https://cardano-mainnet.blockfrost.io/api/v0", projectId := pid }

  -- in-memory state; swap for persisted files if you want durability across restarts
  let lastBlockRef ← IO.mkRef (none : Option String)
  let seenScripts  ← IO.mkRef (HashSet.emptyWithCapacity 0 : HashSet String)
  let statsRef     ← IO.mkRef ({} : Examples.ForwardScan.Stats)

  let modelRef ← IO.mkRef ({} : Examples.Tui.Model)
  let bus      := { model := modelRef }
  let _uiTask  ← IO.asTask (Examples.Tui.runUi bus) Task.Priority.dedicated
  BF.run env do
    Examples.ForwardScan.loop bus "scripts-out" lastBlockRef seenScripts statsRef
