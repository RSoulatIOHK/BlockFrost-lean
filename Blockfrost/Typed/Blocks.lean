import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace blocks
  def latest : BF (Except BFApiError BFBlock) :=
    Blockfrost.blocks.latest.getJsonM (α := BFBlock)

  def byHash (id : String) : BF (Except BFApiError BFBlock) :=
    Blockfrost.blocks.byHash id |>.getJsonM (α := BFBlock)

  namespace latest
    def txsCbor : BF (Except BFApiError (List TxHashCBOR)) :=
      Blockfrost.blocks.latest.txs.cbor.getJsonM (α := List TxHashCBOR)
  end latest
end blocks

end Blockfrost.Typed
