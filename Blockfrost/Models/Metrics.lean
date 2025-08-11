import Lean.Data.Json
import Blockfrost.Utils
open Blockfrost.Utils

namespace Blockfrost

-- Get /metrics
structure BFMetrics where
  time : Nat
  calls : Nat
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFMetrics where
  toString m :=
    s!"{m.calls} call{plural m.calls} @ {m.time}s (unix)"

-- GET /metrics/endpoints
structure BFEndpoints where
  time : Nat
  calls : Nat
  endpoint : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFEndpoints where
  toString e :=
    s!"{e.calls} call{plural e.calls} @ {e.time}s (unix) for endpoint {e.endpoint}"
end Blockfrost
