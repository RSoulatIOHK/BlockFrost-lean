import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace metadata
  namespace txs
    -- GET /metadata/txs/labels
    @[inline] def labels : BF (Except BFApiError (Array BFMetadataTxsLabels)) :=
      Blockfrost.metadata.txs.labels.getJsonM (α := Array BFMetadataTxsLabels)

    namespace labels
      -- GET /metadata/txs/labels/{label}
      def byLabel (label : String) : BF (Except BFApiError BFMetadataTxsLabels) :=
        Blockfrost.metadata.txs.labels.byLabel label |>.getJsonM (α := BFMetadataTxsLabels)

      -- GET /metadata/txs/labels/{label}/cbor
      def cbor (label : String) : BF (Except BFApiError BFMetadataTxsLabelsCbor) :=
        Blockfrost.metadata.txs.labels.cbor label |>.getJsonM (α := BFMetadataTxsLabelsCbor)
    end labels
  end txs
end metadata
end Blockfrost.Typed
