import Lean.Data.Json

namespace Blockfrost

/-- GET /addresses/{address} -/
structure BFAddress where
  address : String
  stake_address? : Option String := none
  type? : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAddress where
  toString (a : BFAddress) := s!"{a.address} (stake: {a.stake_address?}, type: {a.type?})"

structure BFUtxoAmount where
  unit     : String
  quantity : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFUtxoAmount where
  toString (a : BFUtxoAmount) := s!"{a.quantity} {a.unit}"

/-- GET /addresses/{address}/utxos -/
structure BFUtxo where
  tx_hash      : String
  output_index : Nat
  amount       : List BFUtxoAmount
  block?       : Option String := none
  data_hash?   : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFUtxo where
  toString (u : BFUtxo) := s!"{u.tx_hash}#{u.output_index} (block: {u.block?}, data_hash: {u.data_hash?}, amount: {u.amount})"

end Blockfrost
