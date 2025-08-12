import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

-- /health
def health : BF (Except BFApiError BFHealth) :=
  Blockfrost.health.getJsonM (α := BFHealth)

namespace health
  -- /health/clock
  def clock : BF (Except BFApiError BFClock) :=
    Blockfrost.health.clock.getJsonM (α := BFClock)
end health

end Blockfrost.Typed
