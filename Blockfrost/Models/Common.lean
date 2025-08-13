import Lean.Data.Json

namespace Blockfrost
  instance : Repr Lean.Json where
    reprPrec j _ := Lean.Json.pretty j

structure BFValue where
  unit : String
  quantity : String
deriving Repr, Lean.FromJson, Lean.ToJson

end Blockfrost
