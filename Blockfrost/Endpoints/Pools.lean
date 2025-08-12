import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost
  -- GET /pools
  @[inline] def pools : Path := Blockfrost.root.seg "pools"

  namespace pools
    -- GET /pools/extended
    @[inline] def extended : Path := pools.seg "extended"

    -- GET /pools/retired
    @[inline] def retired : Path := pools.seg "retired"

    -- GET /pools/{pool_id}
    @[inline] def byId (pool_id : String) : Path := pools.seg pool_id

    -- GET /pools/{pool_id}/history
    @[inline] def history (pool_id : String) : Path := byId pool_id |>.seg "history"

    -- GET /pools/{pool_id}/metadata
    @[inline] def metadata (pool_id : String) : Path := byId pool_id |>.seg "metadata"

    -- GET /pools/{pool_id}/relays
    @[inline] def relays (pool_id : String) : Path := byId pool_id |>.seg "relays"

    -- GET /pools/{pool_id}/delegators
    @[inline] def delegators (pool_id : String) : Path := byId pool_id |>.seg "delegators"

    -- GET /pools/{pool_id}/blocks
    @[inline] def blocks (pool_id : String) : Path := byId pool_id |>.seg "blocks"

    -- GET /pools/{pool_id}/updates
    @[inline] def updates (pool_id : String) : Path := byId pool_id |>.seg "updates"

    -- GET /pools/{pool_id}/votes
    @[inline] def votes (pool_id : String) : Path := byId pool_id |>.seg "votes"
  end pools
end Blockfrost
