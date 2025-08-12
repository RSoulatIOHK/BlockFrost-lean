import Lean.Data.Json
import Lean.Data.Json.FromToJson

import Blockfrost.Models.Accounts
import Blockfrost.Models.Addresses
import Blockfrost.Models.Assets
import Blockfrost.Models.Blocks
import Blockfrost.Models.Epochs
import Blockfrost.Models.Governance
import Blockfrost.Models.Health
import Blockfrost.Models.Ledger
import Blockfrost.Models.Mempool
import Blockfrost.Models.Metadata
import Blockfrost.Models.Metrics
import Blockfrost.Models.Network
import Blockfrost.Models.Pools
import Blockfrost.Models.Root
import Blockfrost.Models.Scripts
import Blockfrost.Models.Transactions

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
