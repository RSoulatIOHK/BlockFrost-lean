import Lean.Data.Json
import Blockfrost.Models.Common
import Lean.Data.Json.FromToJson
import Blockfrost.Models.Derive

namespace Blockfrost

/-- GET /scripts -/
structure BFScript where
  script_hash : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFScript where

/-- GET /scripts/{script_hash} -/
structure BFScriptInfo where
  script_hash : String
  type : String -- TODO: enum?
  serialized_size? : Option Int := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFScriptInfo where

-- GET /scripts/{script_hash}/json
structure BFScriptJson where
  json : Lean.Json -- inductive of several types
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFScriptJson where

-- GET /scripts/{script_hash}/cbor
structure BFScriptCbor where
  cbor? : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFScriptCbor where

-- GET /scripts/{script_hash}/redeemers
structure BFScriptRedeemer where
  tx_hash : String
  tx_index : Int
  purpose : String -- TODO: enum?
  redeemer_data_hash : String
  datum_hash? : Option String := none -- (deprecated)
  unit_mem : String
  unit_steps : String
  fee : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFScriptRedeemer where

-- GET /scripts/datum/{datum_hash}
structure BFScriptDatum where
  json_value : Lean.Json
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFScriptDatum where

-- GET /scripts/datum/{datum_hash}/cbor
structure BFScriptDatumCbor where
  cbor : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFScriptDatumCbor where

end Blockfrost
