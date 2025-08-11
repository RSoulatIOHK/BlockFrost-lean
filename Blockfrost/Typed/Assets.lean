import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace assets
  def byHash (assetId : String) : BF BFAsset :=
    Blockfrost.assets.byHash assetId |>.getJsonM (α := BFAsset)
end assets

end Blockfrost.Typed
