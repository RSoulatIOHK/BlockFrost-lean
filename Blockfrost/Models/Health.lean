import Lean.Data.Json
import Blockfrost.Models.Derive

namespace Blockfrost.Models

-- GET /
structure BFRoot where
  url : String
  version : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFRoot where

-- GET /health
structure BFHealth where
  is_healthy : Bool
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFHealth where

-- Get /health/clock
structure BFClock where
  server_time : Nat
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFClock where

end Blockfrost.Models
