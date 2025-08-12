import CurlFFI.Curl
import Lean.Data.Json
import Lean.Data.Json.FromToJson
import Blockfrost.Models.Models

namespace Blockfrost

structure Env where
  base      : String
  projectId : String
deriving Repr

inductive BFError
  | network (msg : String)
  | parse   (msg : String) (body : String)
  | decode  (msg : String) (body : String)
  | api     (status : Int) (err : String) (msg : String)
deriving Repr

instance : ToString BFError where
  toString (e : BFError) := match e with
    | .network msg => s!"Network error: {msg}"
    | .parse msg body => s!"Parse error: {msg} (body: {body})"
    | .decode msg body => s!"Decode error: {msg} (body: {body})"
    | .api status err msg => s!"API error {status}: {err} - {msg}"

abbrev BF := ReaderT Env (ExceptT BFError IO)

namespace BF
def runE (env : Env) (m : BF α) : IO (Except BFError α) :=
  ExceptT.run (ReaderT.run m env)

def run (env : Env) (m : BF α) : IO α := do
  match (← runE env m) with
  | .ok a      => pure a
  | .error err => throw <| IO.userError s!"Blockfrost error: {repr err}"
end BF

@[inline] private def authHeaders (env : Env) : Array (String × String) :=
  #[(("project_id"), env.projectId)]

@[inline] private def renderUrl (base : String) (segs : Array String) (qs : Array (String × String)) : String :=
  let path := "/" ++ String.intercalate "/" segs.toList
  if qs.isEmpty then base ++ path
  else
    let q := String.intercalate "&" (qs.toList.map (fun (k,v) => s!"{k}={v}"))
    s!"{base}{path}?{q}"

def getStringM (segs : Array String) (qs : Array (String × String) := #[]) : BF String := do
  let env ← read
  let url := renderUrl env.base segs qs
  let headers := authHeaders env

  IO.println s!"[BF] GET {url}"
  for (k, v) in headers do
    IO.println s!"[BF]   {k}: {v}"

  try
    Curl.curlGetWithHeaders url headers
  catch e : IO.Error =>
    throw <| BFError.network e.toString

/-- Try to decode Blockfrost error envelope (403, 404, etc.) and raise BFError.api. -/
@[inline] private def checkApiError (body : String) : Except BFError Unit := Id.run do
  match Lean.Json.parse body with
  | .ok j =>
    match Lean.fromJson? (α := Blockfrost.Models.BFApiError) j with
    | .ok e =>
      if e.status_code >= 400 then
        .error <| BFError.api e.status_code e.error e.message
      else .ok ()
    | .error _ => .ok ()
  | .error _ => .ok ()

/-- Try to decode a Blockfrost error JSON. Returns `some` if it looks like one. -/
@[inline] private def decodeApiError (body : String) : Option Blockfrost.Models.BFApiError :=
  match Lean.Json.parse body with
  | .ok j =>
    match Lean.fromJson? (α := Blockfrost.Models.BFApiError) j with
    | .ok e       => some e
    | .error _    => none
  | .error _      => none

def getJsonM [Lean.FromJson α] (segs : Array String) (qs : Array (String × String) := #[]) : BF (Except Blockfrost.Models.BFApiError α) := do
  let body ← getStringM segs qs

  -- Try to decode as API error first
  if let some apiError := decodeApiError body then
    return .error apiError
  else
    -- Parse as success type
    match Lean.Json.parse body with
    | .error pe => throw <| BFError.parse pe body
    | .ok j =>
      match Lean.fromJson? (α := α) j with
      | .ok x       => return .ok x
      | .error derr => throw <| BFError.decode derr body

end Blockfrost
