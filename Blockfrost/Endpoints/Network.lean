import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost
  -- GET /network
  @[inline] def network : Path := Blockfrost.root.seg "network"
  namespace network
    -- GET /network/eras
    @[inline] def eras : Path := network.seg "eras"
  end network
end Blockfrost
