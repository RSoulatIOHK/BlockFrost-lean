import Lean.Data.Json
import Lean.Data.Json.FromToJson
import Blockfrost.Models.Derive
import Blockfrost.Models.Common
namespace Blockfrost

/-- GET /mempool/ /mempool/addresses/{address} -/
structure BFMempool where
  tx_hash : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFMempool where

structure BFMempoolTx where
  hash : String
  output_amount : List BFValue
  fees : String
  deposit : String
  size : Int
  invalid_before : Option String := none
  invalid_hereafter : Option String := none
  utxo_count : Int
  withdrawal_count : Int
  mir_cert_count : Int
  delegation_count : Int
  stake_cert_count : Int
  pool_update_count : Int
  pool_retire_count : Int
  asset_mint_or_burn_count : Int
  redeemer_count : Int
  valid_contract : Bool
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFMempoolTx where

structure BFMempoolInput where
  address : String
  tx_hash : String
  output_index : Int
  collateral : Bool
  reference : Bool
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFMempoolInput where

structure BFMempoolOutput where
  address : String
  amount : List BFValue
  output_index : Int
  data_hash? : Option String := none
  inline_datum? : Option String := none
  collateral : Bool
  reference_script_hash? : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFMempoolOutput where

structure BFMempoolRedeemer where
  tx_index : Int
  purpose : String -- TODO: Enum type?
  unit_mem : String
  unit_steps : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFMempoolRedeemer where

structure BFMempoolTxInfo where
  tx : BFMempoolTx
  inputs : List BFMempoolInput
  outputs : List BFMempoolOutput
  redeemers? : Option (List BFMempoolRedeemer) := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFMempoolTxInfo where

end Blockfrost
