import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace addresses
  -- GET /addresses/{address}
  def byAddress (addr : String) : BF (Except BFApiError BFAddressInfo) :=
    Blockfrost.addresses.byAddress addr |>.getJsonM (α := BFAddressInfo)

  -- GET /addresses/{address}/extended
  def extended (addr : String) : BF (Except BFApiError BFAddressExtended) :=
    Blockfrost.addresses.extended addr |>.getJsonM (α := BFAddressExtended)

  -- GET /addresses/{address}/total
  def total (addr : String) : BF (Except BFApiError BFAddressTotal) :=
    Blockfrost.addresses.total addr |>.getJsonM (α := BFAddressTotal)

  -- GET /addresses/{address}/utxos
  def utxos (addr : String) : BF (Except BFApiError (List BFUtxo)) :=
    Blockfrost.addresses.utxos addr |>.getJsonM (α := List BFUtxo)

  namespace utxos
    -- GET /addresses/{address}/utxos/{asset}
    def byAsset (addr : String) (asset : String) : BF (Except BFApiError (List BFUtxo)) :=
      Blockfrost.addresses.utxos.byAsset addr asset |>.getJsonM (α := List BFUtxo)
  end utxos

  -- GET /addresses/{address}/txs (deprecated)
  def txs (addr : String) : BF (Except BFApiError (List BFAddressTxs)) :=
    Blockfrost.addresses.txs addr |>.getJsonM (α := List BFAddressTxs)

  -- GET /addresses/{address}/transactions
  def transactions (addr : String) : BF (Except BFApiError (List BFAddressTransactions)) :=
    Blockfrost.addresses.transactions addr |>.getJsonM (α := List BFAddressTransactions)
end addresses

end Blockfrost.Typed
