import Lean.Data.Json

namespace Blockfrost

/-- GET /epochs/latest -/
structure BFEpoch where
  epoch : Nat
  start_time? : Option Nat := none
  end_time?   : Option Nat := none
  first_block_time? : Option Nat := none
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFEpoch where
  toString (e : BFEpoch) := s!"Epoch {e.epoch} (start: {e.start_time?}, end: {e.end_time?}, first block time: {e.first_block_time?})"

end Blockfrost
