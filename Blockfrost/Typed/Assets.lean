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
end assets

end Blockfrost.Typed
