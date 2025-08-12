import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost
  -- Private as this is not a real API endpoint
  private def governance_root : Path := Blockfrost.root.seg "governance"

  namespace governance
    -- GET /governance/dreps
    @[inline] def dreps : Path := governance_root.seg "dreps"
    namespace dreps
      -- GET /governance/dreps/{drep_id}
      @[inline] def byDrep (drepId : String) : Path := dreps.seg drepId

      -- GET /governance/dreps/{drep_id}/delegators
      @[inline] def delegators (drepId : String) : Path := byDrep drepId |>.seg "delegators"

      -- GET /governance/dreps/{drep_id}/metadata
      @[inline] def metadata (drepId : String) : Path := byDrep drepId |>.seg "metadata"

      -- GET /governance/dreps/{drep_id}/updates
      @[inline] def updates (drepId : String) : Path := byDrep drepId |>.seg "updates"

      -- GET /governance/dreps/{drep_id}/votes
      @[inline] def votes (drepId : String) : Path := byDrep drepId |>.seg "votes"
    end dreps

    namespace proposals
      -- GET /governance/proposals
      @[inline] def root : Path := governance_root.seg "proposals"

      -- GET /governance/proposals/{tx_hash}/{cert_index}
      @[inline] def byTxAndCert (txHash : String) (certIndex : Nat) : Path :=
        root.seg txHash |>.seg (toString certIndex)

      -- GET /governance/proposals/{tx_hash}/{cert_index}/parameters
      @[inline] def parameters (txHash : String) (certIndex : Nat) : Path :=
        byTxAndCert txHash certIndex |>.seg "parameters"

      -- GET /governance/proposals/{tx_hash}/{cert_index}/withdrawals
      @[inline] def withdrawals (txHash : String) (certIndex : Nat) : Path :=
        byTxAndCert txHash certIndex |>.seg "withdrawals"

      -- GET /governance/proposals/{tx_hash}/{cert_index}/votes
      @[inline] def votes (txHash : String) (certIndex : Nat) : Path :=
        byTxAndCert txHash certIndex |>.seg "votes"

      -- GET /governance/proposals/{tx_hash}/{cert_index}/metadata
      @[inline] def metadata (txHash : String) (certIndex : Nat) : Path :=
        byTxAndCert txHash certIndex |>.seg "metadata"
    end proposals
end governance
end Blockfrost
