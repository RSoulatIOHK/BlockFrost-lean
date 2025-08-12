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
  def utxos (h : String) : BF (Except BFApiError (BFTxUtxo)) :=
    Blockfrost.txs.utxos h |>.getJsonM (α := BFTxUtxo)

  -- GET /txs/{hash}/stakes
  def stakes (h : String) : BF (Except BFApiError (List BFTxStake)) :=
    Blockfrost.txs.stakes h |>.getJsonM (α := List BFTxStake)

  -- GET /txs/{hash}/delegations
  def delegations (h : String) : BF (Except BFApiError (List BFTxDelegation)) :=
    Blockfrost.txs.delegations h |>.getJsonM (α := List BFTxDelegation)

  -- GET /txs/{hash}/withdrawals
  def withdrawals (h : String) : BF (Except BFApiError (List BFTxWithdrawal)) :=
    Blockfrost.txs.withdrawals h |>.getJsonM (α := List BFTxWithdrawal)

  -- GET /txs/{hash}/mirs
  def mirs (h : String) : BF (Except BFApiError (List BFTxMir)) :=
    Blockfrost.txs.mirs h |>.getJsonM (α := List BFTxMir)

  -- GET /txs/{hash}/pool_updates
  def poolUpdates (h : String) : BF (Except BFApiError (List BFTxPoolUpdate)) :=
    Blockfrost.txs.poolUpdates h |>.getJsonM (α := List BFTxPoolUpdate)

  -- GET /txs/{hash}/pool_retires
  def poolRetires (h : String) : BF (Except BFApiError (List BFTxPoolRetire)) :=
    Blockfrost.txs.poolRetires h |>.getJsonM (α := List BFTxPoolRetire)

  -- GET /txs/{hash}/metadata
  def metadata (h : String) : BF (Except BFApiError (List BFTxMetadata)) :=
    Blockfrost.txs.metadata h |>.getJsonM (α := List BFTxMetadata)

  namespace metadata
    -- GET /txs/{hash}/metadata/cbor
    def cbor (h : String) : BF (Except BFApiError (List BFTxMetadataCbor)) :=
      Blockfrost.txs.metadata.cbor h |>.getJsonM (α := List BFTxMetadataCbor)
  end metadata

  -- GET /txs/{hash}/redeemers
  def redeemers (h : String) : BF (Except BFApiError (List BFTxRedeemer)) :=
    Blockfrost.txs.redeemers h |>.getJsonM (α := List BFTxRedeemer)

  -- GET /txs/{hash}/required_signers
  def requiredSigners (h : String) : BF (Except BFApiError (List BFTxRequiredSigner)) :=
    Blockfrost.txs.requiredSigners h |>.getJsonM (α := List BFTxRequiredSigner)

  -- GET /txs/{hash}/cbor
  def cbor (h : String) : BF (Except BFApiError BFTxCbor) :=
    Blockfrost.txs.cbor h |>.getJsonM (α := BFTxCbor)

  -- POST /txs/submit
  -- def submit : BF (Except BFApiError BFTxSubmitResponse) :=
  --   Blockfrost.txs.submit.postJsonM (α := BFTxSubmitResponse)
end txs

end Blockfrost.Typed
