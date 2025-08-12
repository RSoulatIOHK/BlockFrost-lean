import Lean.Data.Json
import Blockfrost.Utils
import Blockfrost.Models.Derive


open Blockfrost.Utils

namespace Blockfrost

-- Get /metrics
structure BFMetrics where
  time : Nat
  calls : Nat
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFMetrics where

-- GET /metrics/endpoints
structure BFEndpoints where
  time : Nat
  calls : Nat
  endpoint : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFEndpoints where

end Blockfrost
