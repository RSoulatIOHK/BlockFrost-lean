import Lean.Data.Json
import Blockfrost.Models.Derive
import Blockfrost.Models.Common

namespace Blockfrost

/-- GET /txs/{hash} -/
structure BFTx where
  hash   : String
  block  : String
  block_height : Int
  block_time : Int
  slot : Int
  index : Int
  output_amount : List BFValue
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
  valid_contract : Bool
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTx where

/-- GET /txs/{hash}/utxos -/
structure BFTxInput where
  address : String
  amount : List BFValue
  tx_hash : String
  output_index : Int
  data_hash? : Option String := none
  inline_datum? : Option String := none
  reference_script_hash? : Option String := none
  collateral : Bool
  reference : Bool
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxInput where

structure BFTxOutput where
  address : String
  amount : List BFValue
  output_index : Int
  data_hash? : Option String := none
  inline_datum? : Option String := none
  collateral : Bool
  reference_script_hash? : Option String := none
  consumed_by_tx? : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxOutput where

structure BFTxUtxo where
  hash : String
  inputs : List BFTxInput
  outputs : List BFTxOutput
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxUtxo where

-- GET /txs/{hash}/stakes
structure BFTxStake where
  cert_index : Int
  address : String
  registration : Bool
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxStake where

-- GET /txs/{hash}/delegations
structure BFTxDelegation where
  index? : Option Int := none -- (deprecated)
  cert_index : Int
  address : String
  pool_id : String
  active_epoch : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxDelegation where

-- GET /txs/{hash}/withdrawals
structure BFTxWithdrawal where
  address : String
  amount : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxWithdrawal where

-- GET /txs/{hash}/mirs
structure BFTxMir where
  pot : String -- TODO: enum?
  cert_index : Int
  address : String
  amount : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxMir where

-- GET /txs/{hash}/pool_updates
structure BFTxsPoolUpdates where
  url? : Option String := none
  hash? : Option String := none
  ticker? : Option String := none
  name? : Option String := none
  description? : Option String := none
  homepage? : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxsPoolUpdates where

structure BFRelay where
  ipv4? : Option String := none
  ipv6? : Option String := none
  dns? : Option String := none
  dns_srv? : Option String := none
  port : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFRelay where

structure BFTxPoolUpdate where
  cert_index : Int
  pool_id : String
  vrf_key : String
  pledge : String
  margin_cost : String
  fixed_cost : String
  reward_account : String
  owners : List String
  metadata? : Option BFTxsPoolUpdates := none
  relays? : Option (List BFRelay) := none
  active_epoch : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxPoolUpdate where

-- GET /txs/{hash}/pool_retires
structure BFTxPoolRetire where
  cert_index : Int
  pool_id : String
  retiring_epoch : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxPoolRetire where

-- GET /txs/{hash}/metadata
structure BFTxMetadata where
  label : String
  json_metadata : Lean.Json
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxMetadata where

-- GET /txs/{hash}/metadata/cbor
structure BFTxMetadataCbor where
  label : String
  cbor_metadata? : Option String := none -- (deprecated)
  metadata : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxMetadataCbor where

-- GET /txs/{hash}/redeemers
structure BFTxRedeemer where
  tx_index : Int
  purpose : String -- TODO: enum?
  script_hash : String
  reader_data_hash : String
  datum_hash? : Option String := none -- (deprecated)
  unit_mem : String
  unit_steps : String
  fee : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxRedeemer where

-- GET /txs/{hash}/required_signers
structure BFTxRequiredSigner where
  witness_hash : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxRequiredSigner where

-- GET /txs/{hash}/cbor
structure BFTxCbor where
  cbor : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTxCbor where

-- POST /txs/submit

end Blockfrost
