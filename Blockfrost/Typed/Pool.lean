import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

-- GET /pools
def pools : BF (Except BFApiError (Array BFPoolListElem)) :=
  Blockfrost.pools.getJsonM (α := Array BFPoolListElem)

namespace pools
  -- GET /pools/extended
  def extended : BF (Except BFApiError (Array BFPoolExtended)) :=
    Blockfrost.pools.extended.getJsonM (α := Array BFPoolExtended)

  -- GET /pools/retired
  def retired : BF (Except BFApiError (Array BFPoolRetired)) :=
    Blockfrost.pools.retired.getJsonM (α := Array BFPoolRetired)

  -- GET /pools/retiring
  def retiring : BF (Except BFApiError (Array BFPoolRetired)) :=
    Blockfrost.pools.retiring.getJsonM (α := Array BFPoolRetired)

  -- GET /pools/{pool_id}
  def byId (poolId : String) : BF (Except BFApiError BFPoolInfo) :=
    Blockfrost.pools.byId poolId |>.getJsonM (α := BFPoolInfo)

  -- GET /pools/{pool_id}/history
  def history (poolId : String) : BF (Except BFApiError (List BFPoolHistory)) :=
    Blockfrost.pools.history poolId |>.getJsonM (α := List BFPoolHistory)

  -- GET /pools/{pool_id}/metadata
  def metadata (poolId : String) : BF (Except BFApiError BFPoolMetadata) :=
    Blockfrost.pools.metadata poolId |>.getJsonM (α := BFPoolMetadata)

  -- GET /pools/{pool_id}/relays
  def relays (poolId : String) : BF (Except BFApiError (Array BFPoolRelay)) :=
    Blockfrost.pools.relays poolId |>.getJsonM (α := Array BFPoolRelay)

  -- GET /pools/{pool_id}/delegators
  def delegators (poolId : String) : BF (Except BFApiError (Array BFPoolDelegator)) :=
    Blockfrost.pools.delegators poolId |>.getJsonM (α := Array BFPoolDelegator)

  -- GET /pools/{pool_id}/blocks
  def blocks (poolId : String) : BF (Except BFApiError (Array BFPoolBlock)) :=
    Blockfrost.pools.blocks poolId |>.getJsonM (α := Array BFPoolBlock)

  -- GET /pools/{pool_id}/updates
  def updates (poolId : String) : BF (Except BFApiError (Array BFPoolUpdate)) :=
    Blockfrost.pools.updates poolId |>.getJsonM (α := Array BFPoolUpdate)

  -- GET /pools/{pool_id}/votes
  def votes (poolId : String) : BF (Except BFApiError (Array BFPoolVote)) :=
    Blockfrost.pools.votes poolId |>.getJsonM (α := Array BFPoolVote)
end pools

end Blockfrost.Typed
