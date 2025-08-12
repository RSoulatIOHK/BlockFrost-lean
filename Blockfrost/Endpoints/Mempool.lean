import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost
  -- GET /mempool
  @[inline] def mempool : Path := Blockfrost.root.seg "mempool"

  namespace mempool
    -- GET /mempool/{hash}
    @[inline] def byHash (hash : String) : Path := mempool.seg hash

    namespace addresses
      -- Private as this is not a real API endpoint
      private def root : Path := mempool.seg "addresses"

      -- GET /mempool/addresses/{address}
      @[inline] def byAddress (address : String) : Path := root.seg address
    end addresses
  end mempool
end Blockfrost
