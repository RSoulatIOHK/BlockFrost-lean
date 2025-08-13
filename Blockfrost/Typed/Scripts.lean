import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models
  -- GET /scripts
def scripts : BF (Except BFApiError (List BFScript)) :=
  Blockfrost.scripts.getJsonM (α := List BFScript)
namespace scripts
  -- GET /scripts/{hash}
  def byHash (hash : String) : BF (Except BFApiError BFScript) :=
    Blockfrost.scripts.byHash hash |>.getJsonM (α := BFScript)

  -- GET /scripts/{hash}/json
  def json (hash : String) : BF (Except BFApiError BFScriptJson) :=
    Blockfrost.scripts.json hash |>.getJsonM (α := BFScriptJson)

  -- GET /scripts/{hash}/cbor
  def cbor (hash : String) : BF (Except BFApiError BFScriptCbor) :=
    Blockfrost.scripts.cbor hash |>.getJsonM (α := BFScriptCbor)

  -- GET /scripts/{hash}/redeemers
  def redeemers (hash : String) : BF (Except BFApiError (List BFScriptRedeemer)) :=
    Blockfrost.scripts.redeemers hash |>.getJsonM (α := List BFScriptRedeemer)

  namespace datum
  -- GET /scripts/datum/{datum_hash}
  def byHash (datum_hash : String) : BF (Except BFApiError BFScriptDatum) :=
    Blockfrost.scripts.datum.byDatumHash datum_hash |>.getJsonM (α := BFScriptDatum)

    -- GET /scripts/datum/{datum_hash}/cbor
    def cbor (datum_hash : String) : BF (Except BFApiError BFScriptDatumCbor) :=
      Blockfrost.scripts.datum.cbor datum_hash |>.getJsonM (α := BFScriptDatumCbor)
  end datum
end scripts
end Blockfrost.Typed
