import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace epochs
  def latest : BF (Except BFApiError BFEpoch) :=
    Blockfrost.epochs.latest.getJsonM (α := BFEpoch)
end epochs

end Blockfrost.Typed
