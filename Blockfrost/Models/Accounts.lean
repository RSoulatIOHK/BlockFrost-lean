import Lean.Data.Json
import Lean.Data.Json.FromToJson

namespace Blockfrost

structure BFAccountHistoryRow where
  active_epoch : Nat
  amount       : String
  pool_id?     : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAccountHistoryRow where
  toString (r : BFAccountHistoryRow) := s!"{r.active_epoch} {r.amount} (pool: {r.pool_id?})"


structure BFReward where
  epoch : Nat
  amount : String
  pool_id :  String
  type : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFReward where
  toString (r : BFReward) := s!"{r.epoch} {r.amount} (pool: {r.pool_id}, type: {r.type})"

end  Blockfrost
