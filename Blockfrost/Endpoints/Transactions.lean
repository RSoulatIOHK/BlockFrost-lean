
import Blockfrost.Path
import Blockfrost.Models.Models
import Blockfrost.Endpoints.Root

namespace Blockfrost

namespace txs
  -- root, private as not an API endpoint
  private def root : Path := Blockfrost.root.seg "txs"

  -- GET /txs/{hash}
  @[inline] def byHash (h : String) : Path := root.seg h

  -- GET /txs/{hash}/utxos
  @[inline] def utxos (h : String) : Path := byHash h |>.seg "utxos"

  -- GET /txs/{hash}/stakes
  @[inline] def stakes (h : String) : Path := byHash h |>.seg "stakes"

  -- GET /txs/{hash}/delegations
  @[inline] def delegations (h : String) : Path := byHash h |>.seg "delegations"

  -- GET /txs/{hash}/withdrawals
  @[inline] def withdrawals (h : String) : Path := byHash h |>.seg "withdrawals"

  -- GET /txs/{hash}/mirs
  @[inline] def mirs (h : String) : Path := byHash h |>.seg "mirs"

  -- GET /txs/{hash}/pool_updates
  @[inline] def poolUpdates (h : String) : Path := byHash h |>.seg "pool_updates"

  -- GET /txs/{hash}/pool_retires
  @[inline] def poolRetires (h : String) : Path := byHash h |>.seg "pool_retires"

  -- GET /txs/{hash}/metadata
  @[inline] def metadata (h : String) : Path := byHash h |>.seg "metadata"

  namespace metadata
    -- GET /txs/{hash}/metadata/cbor
    @[inline] def cbor (h : String) : Path := metadata h |>.seg "cbor"
  end metadata

  -- GET /txs/{hash}/redeemers
  @[inline] def redeemers (h : String) : Path := byHash h |>.seg "redeemers"

  -- GET /txs/{hash}/required_signers
  @[inline] def requiredSigners (h : String) : Path := byHash h |>.seg "required_signers"

  -- GET /txs/{hash}/cbor
  @[inline] def cbor (h : String) : Path := byHash h |>.seg "cbor"

  -- POST /txs/submit
  @[inline] def submit : Path := root.seg "submit"

end txs
