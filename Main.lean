import CurlFFI.Curl
import Lean.Data.Json

open Curl Lean

def main : IO Unit := do
  let url := "https://cardano-preprod.blockfrost.io/api/v0/health"
  let projectId := "preprod4HV6tAVhPllD0qI3ywimrxGuQu9gsclp"
  let body ← curlGetWithHeaders url #[(("project_id"), projectId)]
  match Json.parse body with
  | .ok j => IO.println s!"health: {Json.pretty j}"
  | .error e => IO.eprintln s!"parse error: {e}"
