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

import Blockfrost.Models.Derive


namespace Blockfrost.Models

-- API Error
structure BFApiError where
  status_code : Int
  error       : String
  message     : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFApiError where
end Blockfrost.Models
