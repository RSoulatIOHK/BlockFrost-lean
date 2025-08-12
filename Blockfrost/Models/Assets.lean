import Lean.Data.Json
import Blockfrost.Models.Common
import Blockfrost.Models.Derive

namespace Blockfrost

structure BFAssetList where
  asset : String
  quantity : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAssetList where

/-- GET /assets/{asset} -/
structure BFAssetInfo where
  asset       : String
  policy_id   : String
  asset_name  : String
  fingerprint : String
  quantity    : String
  initial_mint_tx_hash : String
  mint_or_burn_count : Int
  onchain_metadata? : Option Lean.Json -- TODO: define a proper type
  onchain_metadata_standard : Option String := none -- TODO: Enum type?
  onchain_metadata_Extra : Option String := none
  metadata : Option Lean.Json -- TODO: define a proper type
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAssetInfo where

end Blockfrost
