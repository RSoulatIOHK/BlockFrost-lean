import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models
-- /root
def root : BF (Except BFApiError BFRoot) :=
  Blockfrost.root.getJsonM (α := BFRoot)

end Blockfrost.Typed
