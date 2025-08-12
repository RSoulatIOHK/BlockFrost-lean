import Lean.Data.Json
import Blockfrost.Models.Common
import Blockfrost.Models.Derive

namespace Blockfrost

structure BFAssetListElement where
  asset : String
  quantity : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAssetListElement where

/-- GET /assets/{asset} -/
structure BFMetadata where
  name : String
  description : String
  ticker : Option String := none
  url : Option String := none
  logo : Option String := none
  decimals : Option Int := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFMetadata where

structure BFAssetInfo where
  asset       : String
  policy_id   : String
  asset_name  : String
  fingerprint : String
  quantity    : String
  initial_mint_tx_hash : String
  mint_or_burn_count : Int
  onchain_metadata? : Option Lean.Json -- Defined as "anyting"
  onchain_metadata_standard : Option String := none -- TODO: Enum type?
  onchain_metadata_Extra : Option String := none
  metadata : Option BFMetadata := none
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAssetInfo where

-- GET /assets/{asset}/history
structure BFAssetHistory where
  tx_hash : String
  action : String -- TODO: Enum type?
  amount : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFAssetHistory where

-- GET /assets/{asset}/txs (deprecated)
abbrev BFAssetTxs := String
instance : PrettyToString BFAssetTxs where

-- GET /assets/{asset}/transactions
structure BFAssetTransaction where
  tx_hash : String
  tx_index : Int
  block_height : Int
  block_time : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFAssetTransaction where

-- GET /assets/{asset}/addresses
structure BFAssetAddresses where
  address : String
  quantity : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFAssetAddresses where

-- GET /assets/{asset}/{policy_id}
abbrev BFAssetPolicyId := BFAssetAddresses
instance : PrettyToString BFAssetPolicyId where

end Blockfrost
