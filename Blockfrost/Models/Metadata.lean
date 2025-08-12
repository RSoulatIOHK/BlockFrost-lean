import Lean.Data.Json
import Blockfrost.Models.Common
import Lean.Data.Json.FromToJson
import Blockfrost.Models.Derive

namespace Blockfrost
/-- GET /metadata/txs/labels -/
structure BFMetadataTxsLabels where
  label : String
  cip10? : Option String := none
  count : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFMetadataTxsLabels where

-- GET /metadata/txs/labels/{label} -/
structure BFMetadataTxsLabelsDetail where
  tx_hash : String
  json_metadata : Lean.Json -- Any of several stuff
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFMetadataTxsLabelsDetail where

-- GET /metadata/txs/labels/{label}/cbor -/
structure BFMetadataTxsLabelsCbor where
  tx_hash : String
  cbor_metadata? : Option String := none -- (deprecated)
  metadata : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFMetadataTxsLabelsCbor where

end Blockfrost
