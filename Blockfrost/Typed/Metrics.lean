import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models
-- GET /metrics
def metrics : BF (Except BFApiError (List BFMetrics)) :=
  Blockfrost.metrics.getJsonM (α := List BFMetrics)

namespace metrics
  -- GET /metrics/endpoints
  def endpoints : BF (Except BFApiError (List BFEndpoints)) :=
    Blockfrost.metrics.endpoints.getJsonM (α := List BFEndpoints)
end metrics

end Blockfrost.Typed
