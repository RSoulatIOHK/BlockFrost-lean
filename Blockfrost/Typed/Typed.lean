import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models
-- /root
def root : BF BFRoot :=
  Blockfrost.root.getJsonM (α := BFRoot)

-- /health
def health : BF BFHealth :=
  Blockfrost.health.getJsonM (α := BFHealth)

namespace health
  -- /health/clock
  def clock : BF BFClock :=
    Blockfrost.health.clock.getJsonM (α := BFClock)
end health

def metrics : BF (Array BFMetrics) :=
  Blockfrost.metrics.getJsonM (α := Array BFMetrics)

namespace metrics
  def endpoints : BF (Array BFEndpoints) :=
    Blockfrost.metrics.endpoints.getJsonM (α := Array BFEndpoints)
end metrics


namespace blocks
  def latest : BF BFBlock :=
    Blockfrost.blocks.latest.getJsonM (α := BFBlock)

  def byHash (id : String) : BF BFBlock :=
    Blockfrost.blocks.hash id |>.getJsonM (α := BFBlock)

  namespace latest
    def txsCbor : BF (List TxHashCBOR) :=
      Blockfrost.blocks.latest.txs.cbor.getJsonM (α := List TxHashCBOR)
  end latest
end blocks

namespace txs
  def byHash (h : String) : BF BFTx :=
    Blockfrost.txs.byHash h |>.getJsonM (α := BFTx)
end txs

namespace addresses
  def info (addr : String) : BF BFAddress :=
    Blockfrost.addresses.at' addr |>.getJsonM (α := BFAddress)

  def utxos (addr : String) : BF (List BFUtxo) :=
    Blockfrost.addresses.utxos addr |>.getJsonM (α := List BFUtxo)
end addresses

namespace assets
  def byHash (assetId : String) : BF BFAsset :=
    Blockfrost.assets.byHash assetId |>.getJsonM (α := BFAsset)
end assets

namespace epochs
  def latest : BF BFEpoch :=
    Blockfrost.epochs.latest.getJsonM (α := BFEpoch)
end epochs

namespace accounts
  namespace byStake
    namespace history
      /-- GET /accounts/{stake}/history with optional pagination filters. -/
      def get (stake : String) (lp : ListParams := {}) : BF (Array BFAccountHistoryRow) := do
        let p := Blockfrost.accounts.byStake.history stake |> Blockfrost.Typed.withParams lp
        p.getJsonM (α := Array BFAccountHistoryRow)
    end history
  end byStake
end accounts
end Blockfrost.Typed
