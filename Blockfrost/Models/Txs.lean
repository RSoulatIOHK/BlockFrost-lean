import Lean.Data.Json

namespace Blockfrost

structure Value where
  unit : String
  quantity : String
deriving Repr, Lean.FromJson, Lean.ToJson

/-- GET /txs/{hash} -/
structure BFTx where
  hash   : String
  block  : String
  block_height : Int
  block_time : Int
  slot : Int
  index : Int
  output_amount : Array Value
  fees : String
  deposit : String
  size : Int
  invalid_before? : Option String := none
  invalid_hereafter? : Option String := none
  utxo_count : Int
  withdrawal_count : Int
  mir_cert_count : Int
  delegation_count : Int
  stake_cert_count : Int
  pool_update_count : Int
  pool_retire_count : Int
  asset_mint_or_burn_count : Int
  redeemer_count : Int
  valid_contract : Int
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFTx where
  toString (tx : BFTx) := s!"{tx.hash} (block: {tx.block}, slot: {tx.slot}, size: {tx.size})"
end Blockfrost
