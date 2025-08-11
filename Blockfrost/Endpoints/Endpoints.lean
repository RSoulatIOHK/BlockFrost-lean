import Blockfrost.Path
import Blockfrost.Models.Models

import Blockfrost.Endpoints.Accounts
import Blockfrost.Endpoints.Root
import Blockfrost.Endpoints.Health
import Blockfrost.Endpoints.Metrics

namespace Blockfrost

-- /blocks
namespace blocks
  @[inline] def root : Path := Blockfrost.root.seg "blocks"
  @[inline] def latest : Path := root.seg "latest"
  @[inline] def hash (h : String) : Path := root.seg h

  namespace latest
    @[inline] def txs  : Path := Blockfrost.blocks.latest.seg "txs"
    namespace txs
      @[inline] def cbor : Path := Blockfrost.blocks.latest.txs.seg "cbor"
    end txs
  end latest

  namespace byHash
    @[inline] def txs (h : String)  : Path := Blockfrost.blocks.hash h |>.seg "txs"
    @[inline] def cbor (h : String) : Path := txs h |>.seg "cbor"
  end byHash
end blocks

-- /addresses
namespace addresses
  @[inline] def root : Path := Blockfrost.root.seg "addresses"
  @[inline] def at' (addr : String) : Path := root.seg addr
  @[inline] def utxos (addr : String) : Path := at' addr |>.seg "utxos"
end addresses

namespace txs
  @[inline] def root : Path := Blockfrost.root.seg "txs"
  @[inline] def byHash (h : String) : Path := root.seg h
  @[inline] def cbor (h : String) : Path := byHash h |>.seg "cbor"

end txs

namespace assets
  @[inline] def root : Path := Blockfrost.root.seg "assets"
  @[inline] def byHash (h : String) : Path := root.seg h
end assets

namespace epochs
  @[inline] def root : Path := Blockfrost.root.seg "epochs"
  @[inline] def latest : Path := root.seg "latest"
end epochs
end Blockfrost
