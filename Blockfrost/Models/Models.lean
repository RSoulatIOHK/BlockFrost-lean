import Lean.Data.Json
import Lean.Data.Json.FromToJson

import Blockfrost.Models.Addresses
import Blockfrost.Models.Accounts
import Blockfrost.Models.Assets
import Blockfrost.Models.Blocks
import Blockfrost.Models.Epochs
import Blockfrost.Models.Health
import Blockfrost.Models.Metrics
import Blockfrost.Models.Root
import Blockfrost.Models.Txs

namespace Blockfrost.Models

-- API Error
structure BFApiError where
  error       : String
  message     : String
  status_code : Nat
deriving Repr, Lean.FromJson, Lean.ToJson

end Blockfrost.Models
