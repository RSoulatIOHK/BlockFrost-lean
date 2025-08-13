-- Main.lean - Script Extractor using existing BlockFrost SDK

import Lean
import Init.System.IO
import Init.Data.String.Basic
import Blockfrost.Typed.Typed

-- Configuration
structure Config where
  blockfrostApiKey : String
  network : String
  outputDir : String
  deriving Repr

-- Helper to extract unique script hashes from transaction
def extractScriptHashes (tx : BlockFrost.Transaction) : List String :=
  let mut scriptHashes : List String := []

  -- From inputs (spending scripts)
  -- Expecting tx.inputs to have script_hash field for plutus scripts
  for input in tx.inputs do
    match input.script_hash with
    | some hash => scriptHashes := hash :: scriptHashes
    | none => continue

  -- From outputs (reference scripts)
  -- Expecting tx.outputs to have reference_script field
  for output in tx.outputs do
    match output.reference_script with
    | some script => scriptHashes := script.script_hash :: scriptHashes
    | none => continue

  -- From withdrawals (stake address scripts)
  -- Expecting tx.withdrawals to have script_hash field
  for withdrawal in tx.withdrawals do
    match withdrawal.script_hash with
    | some hash => scriptHashes := hash :: scriptHashes
    | none => continue

  -- From certificates (delegation/pool scripts)
  -- Expecting tx.certificates to have script_hash field
  for cert in tx.certificates do
    match cert.script_hash with
    | some hash => scriptHashes := hash :: scriptHashes
    | none => continue

  -- From minting (policy scripts)
  -- Expecting tx.mint to have policy_id that equals script_hash for plutus scripts
  for mint in tx.mint do
    scriptHashes := mint.policy_id :: scriptHashes

  scriptHashes.eraseDups

-- Write CBOR hex string to file (for aiken)
def writeCborToFile (cborHex : String) (filePath : String) : IO Unit := do
  try
    let handle ← IO.FS.Handle.mk filePath IO.FS.Mode.write
    handle.putStr cborHex
    handle.flush
  catch e =>
    IO.println s!"Error writing CBOR file {filePath}: {e}"
    throw e

-- Call aiken to decode CBOR to UPLC
def decodeCborToUplc (cborFile : String) (uplcFile : String) : IO Bool := do
  try
    let proc := {
      cmd := "aiken",
      args := #["uplc", "decode", cborFile, "--cbor"],
      stdin := IO.Process.Stdio.null,
      stdout := IO.Process.Stdio.piped,
      stderr := IO.Process.Stdio.piped
    }

    let child ← IO.Process.spawn proc
    let output ← child.stdout.readToEnd
    let stderr ← child.stderr.readToEnd
    let exitCode ← child.wait

    if exitCode == 0 then
      let handle ← IO.FS.Handle.mk uplcFile IO.FS.Mode.write
      handle.putStr output
      handle.flush
      IO.println s!"✓ Converted {cborFile} → {uplcFile}"
      return true
    else
      IO.println s!"✗ Aiken decode failed for {cborFile}: {stderr}"
      return false
  catch e =>
    IO.println s!"✗ Error calling aiken: {e}"
    return false

-- Process a single script hash
def processScript (api : BlockFrost.API) (config : Config) (scriptHash : String) : IO Bool := do
  IO.println s!"Processing script: {scriptHash}"

  try
    -- GET /scripts/{script_hash}/cbor - Get script CBOR
    let scriptCbor ← api.getScriptCbor scriptHash

    let cborFile := s!"{config.outputDir}/{scriptHash}.cbor"
    let uplcFile := s!"{config.outputDir}/{scriptHash}.uplc"

    -- Write CBOR to temporary file
    writeCborToFile scriptCbor.cbor cborFile

    -- Convert to UPLC using aiken
    let success ← decodeCborToUplc cborFile uplcFile

    if success then
      -- Clean up temporary CBOR file
      IO.FS.removeFile cborFile
      return true
    else
      return false

  catch e =>
    IO.println s!"✗ Error processing script {scriptHash}: {e}"
    return false

-- Main processing function
def processTransaction (api : BlockFrost.API) (config : Config) (txHash : String) : IO Unit := do
  IO.println s!"Processing transaction: {txHash}"
  IO.println s!"Output directory: {config.outputDir}"
  IO.println ""

  try
    -- Create output directory
    IO.FS.createDirAll config.outputDir

    -- GET /txs/{hash}/utxos - Get transaction inputs/outputs with UTXOs
    let txUtxos ← api.getTransactionUtxos txHash

    -- GET /txs/{hash} - Get basic transaction info
    let txInfo ← api.getTransaction txHash

    -- GET /txs/{hash}/withdrawals - Get withdrawals (if any)
    let withdrawals ← api.getTransactionWithdrawals txHash

    -- GET /txs/{hash}/mints - Get minting info (if any)
    let mints ← api.getTransactionMints txHash

    -- GET /txs/{hash}/delegations - Get delegation certificates (if any)
    let delegations ← api.getTransactionDelegations txHash

    -- GET /txs/{hash}/pool_updates - Get pool registration/updates (if any)
    let poolUpdates ← api.getTransactionPoolUpdates txHash

    -- GET /txs/{hash}/pool_retires - Get pool retirements (if any)
    let poolRetires ← api.getTransactionPoolRetires txHash

    -- Combine all into transaction structure (you'll need to adapt this to your types)
    let fullTx : BlockFrost.Transaction := {
      hash := txHash,
      inputs := txUtxos.inputs,
      outputs := txUtxos.outputs,
      withdrawals := withdrawals,
      mint := mints,
      certificates := delegations ++ poolUpdates ++ poolRetires
      -- Add other fields as needed from txInfo
    }

    -- Extract all script hashes
    let scriptHashes := extractScriptHashes fullTx

    if scriptHashes.isEmpty then
      IO.println "No scripts found in this transaction."
      return

    IO.println s!"Found {scriptHashes.length} unique script(s):"
    for hash in scriptHashes do
      IO.println s!"  - {hash}"
    IO.println ""

    -- Process each script
    let mut successCount := 0
    for scriptHash in scriptHashes do
      let success ← processScript api config scriptHash
      if success then
        successCount := successCount + 1

    IO.println ""
    IO.println s!"Summary: {successCount}/{scriptHashes.length} scripts successfully converted to UPLC"

  catch e =>
    IO.println s!"Error processing transaction: {e}"

-- Load configuration from environment and args
def loadConfig (args : List String) : IO Config := do
  -- Get API key from environment
  let apiKey ← match ← IO.getEnv "BLOCKFROST_API_KEY" with
    | some key =>
      if key.trim.isEmpty then
        throw (IO.userError "BLOCKFROST_API_KEY is empty")
      else
        pure key.trim
    | none =>
      throw (IO.userError "BLOCKFROST_API_KEY environment variable not set")

  -- Get network from environment (default to mainnet)
  let network := (← IO.getEnv "BLOCKFROST_NETWORK").getD "mainnet"

  -- Get output directory from args or default
  let outputDir := match args.get? 1 with
    | some dir => dir
    | none => "./scripts_output"

  return { blockfrostApiKey := apiKey, network := network, outputDir := outputDir }

-- Validate transaction hash format
def isValidTxHash (hash : String) : Bool :=
  hash.length == 64 && hash.all (fun c => c.isDigit || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F'))

-- Main function
def main (args : List String) : IO UInt32 := do
  -- Show usage if no args
  if args.isEmpty then
    IO.println "Usage: script-extractor <transaction_hash> [output_directory]"
    IO.println ""
    IO.println "Environment variables:"
    IO.println "  BLOCKFROST_API_KEY  - Your Blockfrost API key (required)"
    IO.println "  BLOCKFROST_NETWORK  - Network: mainnet, testnet, preview, preprod (default: mainnet)"
    IO.println ""
    IO.println "Examples:"
    IO.println "  export BLOCKFROST_API_KEY=mainnet_your_key_here"
    IO.println "  export BLOCKFROST_NETWORK=mainnet"
    IO.println "  ./script-extractor abc123def456... ./my_scripts"
    IO.println ""
    IO.println "  export BLOCKFROST_API_KEY=preview_your_key_here"
    IO.println "  export BLOCKFROST_NETWORK=preview"
    IO.println "  ./script-extractor def789abc012... ./testnet_scripts"
    return 1

  try
    -- Load configuration
    let config ← loadConfig args
    let txHash := args.head!

    -- Validate transaction hash
    if not (isValidTxHash txHash) then
      IO.println s!"Error: Invalid transaction hash format: {txHash}"
      IO.println "Transaction hash should be 64 characters of hexadecimal"
      return 1

    -- Initialize BlockFrost API (you'll map this to your API constructor)
    let api ← BlockFrost.API.new config.blockfrostApiKey config.network

    IO.println "Script Extractor"
    IO.println "================"
    IO.println s!"Network: {config.network}"
    IO.println s!"Transaction: {txHash}"
    IO.println ""

    -- Process the transaction
    processTransaction api config txHash

    IO.println ""
    IO.println "✓ Processing complete!"
    return 0

  catch e =>
    IO.println s!"Error: {e}"
    return 1

-- Expected API endpoints (comments for mapping to your implementation):
/-
BlockFrost.API.new : String → String → IO BlockFrost.API
  -- Constructor for your API client

api.getTransactionUtxos : String → IO BlockFrost.TransactionUtxos
  -- GET /txs/{hash}/utxos

api.getTransaction : String → IO BlockFrost.TransactionInfo
  -- GET /txs/{hash}

api.getTransactionWithdrawals : String → IO (List BlockFrost.Withdrawal)
  -- GET /txs/{hash}/withdrawals

api.getTransactionMints : String → IO (List BlockFrost.Mint)
  -- GET /txs/{hash}/mints

api.getTransactionDelegations : String → IO (List BlockFrost.Delegation)
  -- GET /txs/{hash}/delegations

api.getTransactionPoolUpdates : String → IO (List BlockFrost.PoolUpdate)
  -- GET /txs/{hash}/pool_updates

api.getTransactionPoolRetires : String → IO (List BlockFrost.PoolRetire)
  -- GET /txs/{hash}/pool_retires

api.getScriptCbor : String → IO BlockFrost.ScriptCbor
  -- GET /scripts/{script_hash}/cbor
-/
