import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost
  -- GET /scripts
  @[inline] def scripts : Path := Blockfrost.root.seg "scripts"

  namespace scripts
    -- GET /scripts/{hash}
    @[inline] def byHash (hash : String) : Path := scripts.seg hash

    -- GET /scripts/{hash}/json
    @[inline] def json (hash : String) : Path := byHash hash |>.seg "json"

    -- GET /scripts/{hash}/cbor
    @[inline] def cbor (hash : String) : Path := byHash hash |>.seg "cbor"

    -- GET /scripts/{hash}/redeemers
    @[inline] def redeemers (hash : String) : Path := byHash hash |>.seg "redeemers"

    namespace datum
      -- GET /scripts/datum/{datum_hash}
      @[inline] def byDatumHash (datum_hash : String) : Path := scripts.seg "datum" |>.seg datum_hash

      -- GET /scripts/datum/{datum_hash}/cbor
      @[inline] def cbor (datum_hash : String) : Path := byDatumHash datum_hash |>.seg "cbor"
    end datum
  end scripts
end Blockfrost
