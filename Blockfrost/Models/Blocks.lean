import Lean.Data.Json
import Blockfrost.Models.Derive

namespace Blockfrost

/-- GET /blocks/latest (and /blocks/{hash_or_number}, next, previous), blocks/slot/{slot_number} -/
structure BFBlock where
  time : Int
  height? : Option Int := none
  hash : String
  slot? : Option Int := none
  epoch? : Option Int := none
  epoch_slot? : Option Int := none
  slot_leader : String
  size : Int
  tx_count : Int
  output? : Option String := none
  fees? : Option String := none
  block_vrf? : Option String := none -- min 65 max 65, what do I do with this?
  op_cert? : Option String := none
  op_cert_counter? : Option String := none
  previous_block? : Option String := none
  next_block? : Option String := none
  confirmations : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFBlock where

-- GET /blocks/latest/txs /blocks/{hash_or_number}/txs
abbrev BFBlockTxs := String
instance : PrettyToString BFBlockTxs where

-- GET /blocks/latest/txs/cbor /blocks/{hash_or_number}/txs/cbor
structure BFBlockTxsCBOR where
  tx_hash : String
  cbor : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFBlockTxsCBOR where


/-- GET /blocks/{hash_or_number}/txs/cbor and /blocks/latest/txs/cbor -/
structure TxHashCBOR where
  hash : String
  cbor : String   -- hex-encoded CBOR
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString TxHashCBOR where

-- GET /blocks/{hash_or_number}/addresses
structure BFTransaction where
  tx_hash : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFTransaction where

structure BFBlockAddresses where
  address : String
  transactions : List BFTransaction
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFBlockAddresses where

end Blockfrost
