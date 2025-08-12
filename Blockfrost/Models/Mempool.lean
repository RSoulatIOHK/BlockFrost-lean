import Lean.Data.Json
import Lean.Data.Json.FromToJson
import Blockfrost.Models.Derive

namespace Blockfrost

/-- GET /mempool/ -/
structure BFMempool where
  tx_hash : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFMempool where



end Blockfrost
