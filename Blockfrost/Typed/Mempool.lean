import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

-- GET /mempool
def mempool : BF (Except BFApiError BFMempool) :=
  Blockfrost.mempool.getJsonM (α := BFMempool)

namespace mempool
  -- GET /mempool/{hash}
  def byHash (hash : String) : BF (Except BFApiError BFMempoolTx) :=
    Blockfrost.mempool.byHash hash |>.getJsonM (α := BFMempoolTx)
  namespace addresses
    -- Private as this is not a real API endpoint
    def byAddress (address : String) : BF (Except BFApiError BFMempool) :=
      Blockfrost.mempool.addresses.byAddress address |>.getJsonM (α := BFMempool)
  end addresses
end mempool
end Blockfrost.Typed
