import Lean.Data.Json

namespace Blockfrost

-- GET root
structure BFRoot where
  url : String
  version : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFRoot where
  toString (r : BFRoot) := s!"{r.url} (version {r.version})"

end Blockfrost
