import Blockfrost.Env
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Typed

open Blockfrost
open Blockfrost.BF
open Blockfrost.Models

def main : IO Unit := do
  let some pid ← IO.getEnv "BLOCKFROST_PROJECT_ID"
    | throw <| IO.userError "Set BLOCKFROST_PROJECT_ID"
  let env : Env := { base := "https://cardano-preprod.blockfrost.io/api/v0", projectId := pid }

  BF.run env do
    -- root check
    let r : BFRoot ← Blockfrost.Typed.root
    IO.println s!"Root: {r}"

    -- health check
    let h : BFHealth ← Blockfrost.Typed.health
    IO.println s!"Health: {h}"

    -- health.clock check
    let c : BFClock ← Blockfrost.Typed.health.clock
    IO.println s!"Clock: {c}"

   -- metrics
    let m : Array BFMetrics ← Blockfrost.Typed.metrics
    IO.println s!"Metrics: {m}"

    -- metrics/endpoints
    let e : Array BFEndpoints ← Blockfrost.Typed.metrics.endpoints
    IO.println s!"Endpoints: {e}"
