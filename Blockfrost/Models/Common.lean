import Lean.Data.Json

namespace Blockfrost.Models
  instance : Repr Lean.Json where
    reprPrec j _ := Lean.Json.pretty j
end Blockfrost.Models
