import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace blocks
  -- GET /blocks/latest
  def latest : BF (Except BFApiError BFBlock) :=
    Blockfrost.blocks.latest.getJsonM (α := BFBlock)

  namespace latest
    -- GET /blocks/latest/txs
    def txs : BF (Except BFApiError (List BFBlockTxs)) :=
      Blockfrost.blocks.latest.txs.getJsonM (α := List BFBlockTxs)

    namespace txs
      -- GET /blocks/latest/txs/cbor
      def cbor : BF (Except BFApiError (List BFBlockTxsCBOR)) :=
        Blockfrost.blocks.latest.txs.cbor.getJsonM (α := List BFBlockTxsCBOR)
    end txs
  end latest

  -- GET /blocks/{hash_or_number}
  def byHash (id : String) : BF (Except BFApiError BFBlock) :=
    Blockfrost.blocks.byHash id |>.getJsonM (α := BFBlock)

  -- GET /blocks/{hash_or_number}/next
  def next (id : String) : BF (Except BFApiError (List BFBlock)) :=
    Blockfrost.blocks.next id |>.getJsonM (α := List BFBlock)

  -- GET /blocks/{hash_or_number}/previous
  def previous (id : String) : BF (Except BFApiError (List BFBlock)) :=
    Blockfrost.blocks.previous id |>.getJsonM (α := List BFBlock)

  namespace slot
    -- GET /blocks/slot/{slot_number}
    def bySlot (n : Nat) : BF (Except BFApiError BFBlock) :=
      Blockfrost.blocks.slot.bySlot n |>.getJsonM (α := BFBlock)
  end slot

  namespace epoch
    -- GET /blocks/epoch/{epoch_number}/slot/{slot_number}
    def byEpochAndSlot (e : Nat) (s : Nat) : BF (Except BFApiError BFBlock) :=
      Blockfrost.blocks.epoch.byEpochAndSlot e s |>.getJsonM (α := BFBlock)
  end epoch

  -- GET /blocks/{hash_or_number}/txs
  def txs (id : String) : BF (Except BFApiError (List BFBlockTxs)) :=
    Blockfrost.blocks.txs id |>.getJsonM (α := List BFBlockTxs)

  namespace txs
    -- GET /blocks/{hash_or_number}/txs/cbor
    def cbor (id : String) : BF (Except BFApiError (List BFBlockTxsCBOR)) :=
      Blockfrost.blocks.txs.cbor id |>.getJsonM (α := List BFBlockTxsCBOR)
  end txs

  -- GET /blocks/{hash_or_number}/addresses
  def addresses (id : String) : BF (Except BFApiError (List BFBlockAddresses)) :=
    Blockfrost.blocks.addresses id |>.getJsonM (α := List BFBlockAddresses)
end blocks

end Blockfrost.Typed
