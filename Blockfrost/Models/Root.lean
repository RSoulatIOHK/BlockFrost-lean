import Lean.Data.Json
import Blockfrost.Models.Derive

namespace Blockfrost

-- GET root
structure BFRoot where
  url : String
  version : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFRoot where


end Blockfrost
