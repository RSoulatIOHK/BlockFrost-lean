import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

  -- GET /assets
  def assets: BF (Except BFApiError (List BFAssetListElement)) :=
    Blockfrost.assets |>.getJsonM (α := List BFAssetListElement )

namespace assets
  -- GET /assets/{asset}
  def byAsset (assetId : String) : BF (Except BFApiError BFAssetInfo) :=
    Blockfrost.assets.byAsset assetId |>.getJsonM (α := BFAssetInfo)

  -- GET /assets/{asset}/history
  def history (assetId : String) : BF (Except BFApiError (List BFAssetHistory)) :=
    Blockfrost.assets.history assetId |>.getJsonM (α := List BFAssetHistory)

  -- GET /assets/{asset}/transactions
  def transactions (assetId : String) : BF (Except BFApiError (List BFAssetTransaction)) :=
    Blockfrost.assets.transactions assetId |>.getJsonM (α := List BFAssetTransaction)

  -- GET /assets/{asset}/addresses
  def addresses (assetId : String) : BF (Except BFApiError (List BFAssetAddresses)) :=
    Blockfrost.assets.addresses assetId |>.getJsonM (α := List BFAssetAddresses)

  namespace policy
    -- GET /assets/policy/{policy_id}
    def byPolicy (policyId : String) : BF (Except BFApiError (List BFAssetListElement)) :=
      Blockfrost.assets.policy.byPolicy policyId |>.getJsonM (α := List BFAssetListElement)
  end policy
end assets

end Blockfrost.Typed
