import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost
  -- GET /assets
  @[inline] def assets : Path := Blockfrost.root.seg "assets"

  namespace assets
    -- GET /assets/{asset}
    @[inline] def byAsset (h : String) : Path := assets.seg h

    -- GET /assets/{asset}/history
    @[inline] def history (h : String) : Path := byAsset h |>.seg "history"
    -- GET /assets/{asset}/txs (deprecated)

    -- GET /assets/{asset}/transactions
    @[inline] def transactions (h : String) : Path := byAsset h |>.seg "transactions"

    -- GET /assets/{asset}/addresses
    @[inline] def addresses (h : String) : Path := byAsset h |>.seg "addresses"

    namespace policy
      -- GET /assets/policy/{policy_id}
      @[inline] def byPolicy (p : String) : Path := assets.seg "policy" |>.seg p

    end policy
  end assets
end Blockfrost
