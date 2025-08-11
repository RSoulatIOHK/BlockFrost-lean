import Lean.Data.Json

namespace Blockfrost

/-- GET /blocks/latest (and /blocks/{hash_or_number}) -/
structure BFBlock where
  hash    : String
  height? : Option Nat := none
  slot?   : Option Nat := none
  epoch?  : Option Nat := none
  time?   : Option Nat := none
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFBlock where
  toString (b : BFBlock) := s!"{b.hash} (height: {b.height?}, slot: {b.slot?}, epoch: {b.epoch?}, time: {b.time?})"

/-- GET /blocks/{hash_or_number}/txs/cbor and /blocks/latest/txs/cbor -/
structure TxHashCBOR where
  hash : String
  cbor : String   -- hex-encoded CBOR
deriving Repr, Lean.FromJson, Lean.ToJson

end Blockfrost
