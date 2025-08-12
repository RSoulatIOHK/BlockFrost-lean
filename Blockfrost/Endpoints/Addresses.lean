import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost

namespace addresses
  -- GET /addresses/{address}
  @[inline] def byAddress (addr : String) : Path :=
    root.seg "addresses" |>.seg addr

  -- GET /addresses/{address}/extended
  @[inline] def extended (addr : String) : Path :=
    byAddress addr |>.seg "extended"

  -- GET /addresses/{address}/total
  @[inline] def total (addr : String) : Path :=
    byAddress addr |>.seg "total"

  -- GET /addresses/{address}/utxos
  @[inline] def utxos (addr : String) : Path :=
    byAddress addr |>.seg "utxos"

  namespace utxos
    -- GET /addresses/{address}/utxos/assets
    @[inline] def byAsset (addr : String) (asset : String) : Path :=
      byAddress addr |>.seg "utxos" |>.seg asset
  end utxos

  -- GET /addresses/{address}/txs (deprecated)
  @[inline] def txs (addr : String) : Path :=
    byAddress addr |>.seg "txs"

  -- GET /addresses/{address}/transactions
  @[inline] def transactions (addr : String) : Path :=
    byAddress addr |>.seg "transactions"
end addresses

end Blockfrost
