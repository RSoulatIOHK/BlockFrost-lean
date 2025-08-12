import Lean.Data.Json

class PrettyToString (α : Type) where

instance {α} [Lean.ToJson α] [PrettyToString α] : ToString α where
  toString a := Lean.Json.pretty (Lean.toJson a)
