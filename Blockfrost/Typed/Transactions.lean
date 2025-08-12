import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace txs
  -- GET /txs
  def byHash (h : String) : BF (Except BFApiError BFTx) :=
    Blockfrost.txs.byHash h |>.getJsonM (α := BFTx)

  -- GET /txs/{hash}/utxos
  def utxos (h : String) : BF (Except BFApiError (Array BFTxUtxo)) :=
    Blockfrost.txs.utxos h |>.getJsonM (α := Array BFTxUtxo)

  -- GET /txs/{hash}/stakes
  def stakes (h : String) : BF (Except BFApiError (Array BFTxStake)) :=
    Blockfrost.txs.stakes h |>.getJsonM (α := Array BFTxStake)

  -- GET /txs/{hash}/delegations
  def delegations (h : String) : BF (Except BFApiError (Array BFTxDelegation)) :=
    Blockfrost.txs.delegations h |>.getJsonM (α := Array BFTxDelegation)

  -- GET /txs/{hash}/withdrawals
  def withdrawals (h : String) : BF (Except BFApiError (Array BFTxWithdrawal)) :=
    Blockfrost.txs.withdrawals h |>.getJsonM (α := Array BFTxWithdrawal)

  -- GET /txs/{hash}/mirs
  def mirs (h : String) : BF (Except BFApiError (Array BFTxMir)) :=
    Blockfrost.txs.mirs h |>.getJsonM (α := Array BFTxMir)

  -- GET /txs/{hash}/pool_updates
  def poolUpdates (h : String) : BF (Except BFApiError (Array BFTxPoolUpdate)) :=
    Blockfrost.txs.poolUpdates h |>.getJsonM (α := Array BFTxPoolUpdate)

  -- GET /txs/{hash}/pool_retires
  def poolRetires (h : String) : BF (Except BFApiError (Array BFTxPoolRetire)) :=
    Blockfrost.txs.poolRetires h |>.getJsonM (α := Array BFTxPoolRetire)

  -- GET /txs/{hash}/metadata
  def metadata (h : String) : BF (Except BFApiError (Array BFTxMetadata)) :=
    Blockfrost.txs.metadata h |>.getJsonM (α := Array BFTxMetadata)

  namespace metadata
    -- GET /txs/{hash}/metadata/cbor
    def cbor (h : String) : BF (Except BFApiError BFTxMetadataCbor) :=
      Blockfrost.txs.metadata.cbor h |>.getJsonM (α := BFTxMetadataCbor)
  end metadata

  -- GET /txs/{hash}/redeemers
  def redeemers (h : String) : BF (Except BFApiError (Array BFTxRedeemer)) :=
    Blockfrost.txs.redeemers h |>.getJsonM (α := Array BFTxRedeemer)

  -- GET /txs/{hash}/required_signers
  def requiredSigners (h : String) : BF (Except BFApiError (Array BFTxRequiredSigner)) :=
    Blockfrost.txs.requiredSigners h |>.getJsonM (α := Array BFTxRequiredSigner)

  -- GET /txs/{hash}/cbor
  def cbor (h : String) : BF (Except BFApiError BFTxCbor) :=
    Blockfrost.txs.cbor h |>.getJsonM (α := BFTxCbor)

  -- POST /txs/submit
  -- def submit : BF (Except BFApiError BFTxSubmitResponse) :=
  --   Blockfrost.txs.submit.postJsonM (α := BFTxSubmitResponse)
end txs

end Blockfrost.Typed
