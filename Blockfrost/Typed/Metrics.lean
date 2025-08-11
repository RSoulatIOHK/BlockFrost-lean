import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

def metrics : BF (Array BFMetrics) :=
  Blockfrost.metrics.getJsonM (α := Array BFMetrics)

namespace metrics
  def endpoints : BF (Array BFEndpoints) :=
    Blockfrost.metrics.endpoints.getJsonM (α := Array BFEndpoints)
end metrics

end Blockfrost.Typed
