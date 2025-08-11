
import Blockfrost.Path
import Blockfrost.Models.Models
import Blockfrost.Endpoints.Root

namespace Blockfrost

-- /health
@[inline] def health : Path := root.seg "health"

namespace health
  @[inline] def clock : Path := health.seg "clock"
end health

end Blockfrost
