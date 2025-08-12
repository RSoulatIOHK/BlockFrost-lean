import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost

private def epochs_root : Path := root.seg "epochs"
-- /epochs
namespace epochs
-- GET /epochs/latest
  @[inline] def latest : Path := epochs_root.seg "latest"

  namespace latest
    -- GET /epochs/latest/parameters
    @[inline] def parameters : Path := latest.seg "parameters"
  end latest

  -- GET /epochs/{epoch}
  @[inline] def byEpoch (epoch : Nat) : Path :=
    epochs_root.seg (toString epoch)

  -- GET /epochs/{epoch}/next
  @[inline] def next (epoch : Nat) : Path :=
    byEpoch epoch |>.seg "next"

  -- GET /epochs/{epoch}/previous
  @[inline] def previous (epoch : Nat) : Path :=
    byEpoch epoch |>.seg "previous"

  -- GET /epochs/{epoch}/stakes
  @[inline] def stakes (epoch : Nat) : Path :=
    byEpoch epoch |>.seg "stakes"

  namespace stakes
    -- GET /epochs/{epoch}/stakes/{pool_id}
    @[inline] def byPool (epoch : Nat) (poolId : String) : Path :=
      stakes epoch |>.seg poolId
  end stakes

  -- GET /epochs/{epoch}/blocks
  @[inline] def blocks (epoch : Nat) : Path :=
    byEpoch epoch |>.seg "blocks"

  namespace blocks
    -- GET /epochs/{epoch}/blocks/{pool_id}
    @[inline] def byPool (epoch : Nat) (poolId : String) : Path :=
      blocks epoch |>.seg poolId
  end blocks

  -- GET /epochs/{epoch}/parameters
  @[inline] def parameters (epoch : Nat) : Path :=
    byEpoch epoch |>.seg "parameters"

end epochs
