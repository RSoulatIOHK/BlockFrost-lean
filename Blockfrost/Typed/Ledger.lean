import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

-- GET /genesis
def genesis : BF (Except BFApiError BFGenesis) :=
  Blockfrost.genesis.getJsonM (α := BFGenesis)

end Blockfrost.Typed
