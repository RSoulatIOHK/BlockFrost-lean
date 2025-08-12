import Lean.Data.Json
import Blockfrost.Models.Common

namespace Blockfrost

structure BFAssetList where
  asset : String
  quantity : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAssetList where
  toString (a : BFAssetList) := s!"{a.asset} ({a.quantity})"

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

instance : ToString BFAssetInfo where
  toString (a : BFAssetInfo) :=
    s!"{a.asset} ({a.quantity}) with policy {a.policy_id} and name {a.asset_name} (fingerprint: {a.fingerprint})"
end Blockfrost
