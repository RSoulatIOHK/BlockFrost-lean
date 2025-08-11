import Lean.Data.Json

namespace Blockfrost

/-- GET /txs/{hash} -/
structure BFTx where
  hash   : String
  block? : Option String := none
  slot?  : Option Nat := none
  size?  : Option Nat := none
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFTx where
  toString (tx : BFTx) := s!"{tx.hash} (block: {tx.block?}, slot: {tx.slot?}, size: {tx.size?})"
end Blockfrost
