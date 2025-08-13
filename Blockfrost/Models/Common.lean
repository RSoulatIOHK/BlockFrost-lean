import Lean.Data.Json
import Blockfrost.Models.Derive

namespace Blockfrost
  instance : Repr Lean.Json where
    reprPrec j _ := Lean.Json.pretty j

structure BFValue where
  unit : String
  quantity : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFValue where

structure BFTransaction where
  tx_hash : String
  tx_index : Int
  block_height : Int
  block_time : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTransaction where


end Blockfrost
