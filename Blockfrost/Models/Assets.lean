import Lean.Data.Json

namespace Blockfrost

/-- GET /assets/{asset} -/
structure BFAsset where
  asset       : String
  policy_id   : String
  asset_name  : String
  fingerprint : String
  quantity?   : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAsset where
  toString (a : BFAsset) := s!"{a.asset} (policy: {a.policy_id}, name: {a.asset_name}, fingerprint: {a.fingerprint}, quantity: {a.quantity?})"

end Blockfrost
