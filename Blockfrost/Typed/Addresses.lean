import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace addresses
  def info (addr : String) : BF BFAddress :=
    Blockfrost.addresses.at' addr |>.getJsonM (α := BFAddress)

  def utxos (addr : String) : BF (List BFUtxo) :=
    Blockfrost.addresses.utxos addr |>.getJsonM (α := List BFUtxo)
end addresses

end Blockfrost.Typed
