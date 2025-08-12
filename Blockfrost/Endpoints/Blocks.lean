
import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost
-- Private as this is not a real API endpoint
private def blocks_root : Path := Blockfrost.root.seg "blocks"

namespace blocks
  -- GET /blocks/latest
  @[inline] def latest : Path := blocks_root.seg "latest"

  namespace latest
    -- GET /blocks/latest/txs
    @[inline] def txs  : Path := Blockfrost.blocks.latest.seg "txs"
    namespace txs
      -- GET /blocks/latest/txs/cbor
      @[inline] def cbor : Path := Blockfrost.blocks.latest.txs.seg "cbor"
    end txs
  end latest

  -- GET /blocks/{hash_or_number}
  @[inline] def byHash (h : String) : Path := blocks_root.seg h

  -- GET /blocks/{hash_or_number}/next
  @[inline] def next (h : String) : Path := byHash h |>.seg "next"

  -- GET /blocks/{hash_or_number}/previous
  @[inline] def previous (h : String) : Path := byHash h |>.seg "previous"

  namespace slot
    -- GET /blocks/slot/{slot_number}
    @[inline] def bySlot (n : Nat) : Path := blocks_root.seg "slot" |>.seg (toString n)
  end slot

  namespace epoch
    -- GET /blocks/epoch/{epoch_number}/slot/{slot_number}
    @[inline] def byEpochAndSlot (e : Nat) (s : Nat) : Path :=
      blocks_root.seg "epoch" |>.seg (toString e) |>.seg "slot" |>.seg (toString s)
  end epoch

  -- GET /blocks/{hash_or_number}/txs
  @[inline] def txs (h : String) : Path := byHash h |>.seg "txs"

  namespace txs
    -- GET /blocks/{hash_or_number}/txs/cbor
    @[inline] def cbor (h : String) : Path := Blockfrost.blocks.txs h |>.seg "cbor"
  end txs

  -- GET /blocks/{hash_or_number}/addresses
  @[inline] def addresses (h : String) : Path := byHash h |>.seg "addresses"

end blocks
