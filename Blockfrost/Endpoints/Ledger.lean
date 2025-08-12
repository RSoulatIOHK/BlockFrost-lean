import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost
  -- GET /genesis
  @[inline] def genesis : Path := Blockfrost.root.seg "genesis"
end Blockfrost
