import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace addresses
  def byAddress (addr : String) : BF (Except BFApiError BFAddressInfo) :=
    Blockfrost.addresses.byAddress addr |>.getJsonM (α := BFAddressInfo)

  def extended (addr : String) : BF (Except BFApiError BFAddressExtended) :=
    Blockfrost.addresses.extended addr |>.getJsonM (α := BFAddressExtended)

  def total (addr : String) : BF (Except BFApiError BFAddressTotal) :=
    Blockfrost.addresses.total addr |>.getJsonM (α := BFAddressTotal)

  def utxos (addr : String) : BF (Except BFApiError (List BFUtxo)) :=
    Blockfrost.addresses.utxos addr |>.getJsonM (α := List BFUtxo)

  namespace utxos
    def byAsset (addr : String) (asset : String) : BF (Except BFApiError BFUtxo) :=
      Blockfrost.addresses.utxos.byAsset addr asset |>.getJsonM (α := BFUtxo)
  end utxos

  -- txs (deprecated)
  def txs (addr : String) : BF (Except BFApiError BFAddressTxs) :=
    Blockfrost.addresses.txs addr |>.getJsonM (α := BFAddressTxs)

  def transactions (addr : String) : BF (Except BFApiError (List BFAddressTransactions)) :=
    Blockfrost.addresses.transactions addr |>.getJsonM (α := List BFAddressTransactions)
end addresses

end Blockfrost.Typed
