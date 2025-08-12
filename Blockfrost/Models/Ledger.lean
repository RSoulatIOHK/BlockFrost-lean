import Lean.Data.Json
import Lean.Data.Json.FromToJson
import Blockfrost.Models.Common
import Blockfrost.Models.Derive

namespace Blockfrost
-- GET /genesis
structure BFGenesis where
  active_slots_coefficient : Float
  update_quorum : Int
  max_lovelace_supply : String
  network_magic : Int
  epoch_length : Int
  system_start : Int
  slots_per_kes_period : Int
  slot_length : Int
  max_kes_evolutions : Int
  security_param : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFGenesis where
end Blockfrost
