import Lean.Data.Json
import Lean.Data.Json.FromToJson

namespace Blockfrost

/-- GET /mempool/ -/
structure BFMempool where
  tx_hash : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFMempool where
  toString (m : BFMempool) := s!"{m.tx_hash}"


end Blockfrost
