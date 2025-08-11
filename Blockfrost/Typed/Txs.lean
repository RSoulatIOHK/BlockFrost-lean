import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace txs
  def byHash (h : String) : BF BFTx :=
    Blockfrost.txs.byHash h |>.getJsonM (α := BFTx)
end txs

end Blockfrost.Typed
