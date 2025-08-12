import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

-- GET /network
def network : BF (Except BFApiError BFNetwork) :=
  Blockfrost.network.getJsonM (α := BFNetwork)

  namespace network
    -- GET /network/eras
    def eras : BF (Except BFApiError (List BFNetworkEra)) :=
      Blockfrost.network.eras.getJsonM (α := List BFNetworkEra)
  end network

end Blockfrost.Typed
