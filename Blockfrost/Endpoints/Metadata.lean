import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost
  -- Private as this is not a real API endpoint
  private def metadata_root : Path := Blockfrost.root.seg "metadata"

  namespace txs
    -- GET /metadata/txs/labels
    @[inline] def labels : Path := metadata_root.seg "txs" |>.seg "labels"

    namespace labels
      -- GET /metadata/txs/labels/{label}
      @[inline] def byLabel (label : String) : Path := labels.seg label

      -- GET /metadata/txs/labels/{label}/cbor
      @[inline] def cbor (label : String) : Path := byLabel label |>.seg "cbor"
    end labels
  end txs
end Blockfrost
