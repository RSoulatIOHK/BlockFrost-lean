-- Blockfrost/Client.lean
import CurlFFI.Curl
import Lean.Data.Json
import Lean.Data.Json.FromToJson

open Lean Curl

namespace Blockfrost

/-- Supported Cardano network bases (pass a full URL here if you want custom). -/
def baseOfNetwork : String → String
  | "mainnet" => "https://cardano-mainnet.blockfrost.io/api/v0"
  | "preprod" => "https://cardano-preprod.blockfrost.io/api/v0"
  | "preview" => "https://cardano-preview.blockfrost.io/api/v0"
  | other     => other  -- allow custom base

@[inline] def authHeaders (projectId : String) : Array (String × String) :=
  #[(("project_id"), projectId)]

/-- GET + parse JSON straight into a Lean value via `FromJson`. -/
def getJson [FromJson α]
    (base : String) (path : String) (projectId : String) : IO α := do
  let url := base ++ path
  let body ← Curl.curlGetWithHeaders url (authHeaders projectId)
  match Json.parse body with
  | .error e =>
      throw <| IO.userError s!"Blockfrost: invalid JSON at {path}: {e}\nBody:\n{body}"
  | .ok j =>
    match fromJson? (α := α) j with
    | .ok x      => pure x
    | .error err =>
      throw <| IO.userError s!"Blockfrost: decode error at {path}: {err}\nBody:\n{body}"

/-- Convenience wrapper that reads BLOCKFROST_PROJECT_ID from the env. -/
def getJsonWithEnv [FromJson α]
    (base : String) (path : String) : IO α := do
  let some pid ← IO.getEnv "BLOCKFROST_PROJECT_ID"
    | throw <| IO.userError "Set BLOCKFROST_PROJECT_ID in your environment."
  getJson (α := α) base path pid

end Blockfrost
