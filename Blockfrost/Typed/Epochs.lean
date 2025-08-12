import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace epochs
  -- GET /epochs/latest
  def latest : BF (Except BFApiError BFEpoch) :=
    Blockfrost.epochs.latest.getJsonM (α := BFEpoch)

  namespace latest
    -- GET /epochs/latest/parameters
    def parameters : BF (Except BFApiError BFEpochParameters) :=
      Blockfrost.epochs.latest.parameters.getJsonM (α := BFEpochParameters)
  end latest
  -- GET /epochs/{epoch}
  def byEpoch (epoch : Nat) : BF (Except BFApiError BFEpoch) :=
    Blockfrost.epochs.byEpoch epoch |>.getJsonM (α := BFEpoch)

  -- GET /epochs/{epoch}/next
  def next (epoch : Nat) : BF (Except BFApiError BFEpoch) :=
    Blockfrost.epochs.next epoch |>.getJsonM (α := BFEpoch)

  -- GET /epochs/{epoch}/previous
  def previous (epoch : Nat) : BF (Except BFApiError BFEpoch) :=
    Blockfrost.epochs.previous epoch |>.getJsonM (α := BFEpoch)

  -- GET /epochs/{epoch}/stakes
  def stakes (epoch : Nat) : BF (Except BFApiError (List BFEpochStake)) :=
    Blockfrost.epochs.stakes epoch |>.getJsonM (α := List BFEpochStake)

  namespace stakes
    -- GET /epochs/{epoch}/stakes/{pool_id}
    def byPool (epoch : Nat) (poolId : String) : BF (Except BFApiError BFEpochStake) :=
      Blockfrost.epochs.stakes.byPool epoch poolId |>.getJsonM (α := BFEpochStake)
  end stakes

  -- GET /epochs/{epoch}/blocks
  def blocks (epoch : Nat) : BF (Except BFApiError (List BFEpochBlock)) :=
    Blockfrost.epochs.blocks epoch |>.getJsonM (α := List BFEpochBlock)

  namespace blocks
    -- GET /epochs/{epoch}/blocks/{pool_id}
    def byPool (epoch : Nat) (poolId : String) : BF (Except BFApiError (List BFEpochBlock)) :=
      Blockfrost.epochs.blocks.byPool epoch poolId |>.getJsonM (α := List BFEpochBlock)
  end blocks

  -- GET /epochs/{epoch}/parameters
  def parameters (epoch : Nat) : BF (Except BFApiError BFEpochParameters) :=
    Blockfrost.epochs.parameters epoch |>.getJsonM (α := BFEpochParameters)

end epochs

end Blockfrost.Typed
