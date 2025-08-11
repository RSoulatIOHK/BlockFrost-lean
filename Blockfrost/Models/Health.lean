import Lean.Data.Json

namespace Blockfrost.Models

-- GET /health
structure BFHealth where
  is_healthy : Bool
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFHealth where
  toString (h : BFHealth) := if h.is_healthy then "true" else "false"

-- Get /health/clock
structure BFClock where
  server_time : Nat
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFClock where
  toString (c : BFClock) := s!"{c.server_time} (UNIX timestamp)"

end Blockfrost.Models
