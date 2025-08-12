import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace governance
  -- GET /governance/dreps
  def dreps : BF (Except BFApiError (List BFDRep)) :=
    Blockfrost.governance.dreps.getJsonM (α := List BFDRep)

  namespace dreps
    -- GET /governance/dreps/{drep_id}
    def byDrep (drepId : String) : BF (Except BFApiError BFDRep) :=
      Blockfrost.governance.dreps.byDrep drepId |>.getJsonM (α := BFDRep)

    -- GET /governance/dreps/{drep_id}/delegators
    def delegators (drepId : String) : BF (Except BFApiError (List BFDRepDelegator)) :=
      Blockfrost.governance.dreps.delegators drepId |>.getJsonM (α := List BFDRepDelegator)

    -- GET /governance/dreps/{drep_id}/metadata
    def metadata (drepId : String) : BF (Except BFApiError BFDRepMetadata) :=
      Blockfrost.governance.dreps.metadata drepId |>.getJsonM (α := BFDRepMetadata)

    -- GET /governance/dreps/{drep_id}/updates
    def updates (drepId : String) : BF (Except BFApiError (List BFDRepUpdate)) :=
      Blockfrost.governance.dreps.updates drepId |>.getJsonM (α := List BFDRepUpdate)

    -- GET /governance/dreps/{drep_id}/votes
    def votes (drepId : String) : BF (Except BFApiError (List BFDRepVote)) :=
      Blockfrost.governance.dreps.votes drepId |>.getJsonM (α := List BFDRepVote)
  end dreps

  namespace proposals
    -- GET /governance/proposals
    def root : BF (Except BFApiError (List BFProposal)) :=
      Blockfrost.governance.proposals.root.getJsonM (α := List BFProposal)

    -- GET /governance/proposals/{tx_hash}/{cert_index}
    def byTxAndCert (txHash : String) (certIndex : Nat) : BF (Except BFApiError BFProposal) :=
      Blockfrost.governance.proposals.byTxAndCert txHash certIndex |>.getJsonM (α := BFProposal)

    -- GET /governance/proposals/{tx_hash}/{cert_index}/parameters
    def parameters (txHash : String) (certIndex : Nat) : BF (Except BFApiError BFProposalParameters) :=
      Blockfrost.governance.proposals.parameters txHash certIndex |>.getJsonM (α := BFProposalParameters)

    -- GET /governance/proposals/{tx_hash}/{cert_index}/withdrawals
    def withdrawals (txHash : String) (certIndex : Nat) : BF (Except BFApiError (List BFProposalWithdrawal)) :=
      Blockfrost.governance.proposals.withdrawals txHash certIndex |>.getJsonM (α := List BFProposalWithdrawal)

    -- GET /governance/proposals/{tx_hash}/{cert_index}/votes
    def votes (txHash : String) (certIndex : Nat) : BF (Except BFApiError (List BFProposalVote)) :=
      Blockfrost.governance.proposals.votes txHash certIndex |>.getJsonM (α := List BFProposalVote)

    -- GET /governance/proposals/{tx_hash}/{cert_index}/metadata
    def metadata (txHash : String) (certIndex : Nat) : BF (Except BFApiError BFProposalMetadata) :=
      Blockfrost.governance.proposals.metadata txHash certIndex |>.getJsonM (α := BFProposalMetadata)
  end proposals
