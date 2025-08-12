import Lean.Data.Json
-- import Blockfrost.Models.Common
import Lean.Data.Json.FromToJson
import Blockfrost.Models.Derive

namespace Blockfrost

/-- GET /network -/
structure BFSupply where
  max : String
  total : String
  circulating : String
  locked : String
  treasury : String
  reserves : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFSupply where

structure BFStake where
  live : String
  active : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFStake where

structure BFNetwork where
  supply : BFSupply
  stake : BFStake
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFNetwork where

-- GET /network/eras
structure BFBoundary where
  time : Nat
  slot : Int
  epoch : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFBoundary where

structure BFNetworkParameter where
 epoch_length : Int
 slot_length : Nat
 safe_zone : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFNetworkParameter where

structure BFNetworkEra where
  start : BFBoundary
  «end» : BFBoundary
  parameters : BFNetworkParameter
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFNetworkEra where

end Blockfrost
