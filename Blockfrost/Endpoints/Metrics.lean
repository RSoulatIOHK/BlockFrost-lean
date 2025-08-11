import Blockfrost.Path
import Blockfrost.Models.Models
import Blockfrost.Endpoints.Root

namespace Blockfrost
  -- GET /metrics
  @[inline] def metrics : Path := root.seg "metrics"

  namespace metrics
  -- GET /metrics/endpoints
    @[inline] def endpoints : Path := metrics.seg "endpoints"
  end metrics

end Blockfrost
