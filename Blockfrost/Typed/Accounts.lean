import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace accounts
  -- GET /accounts/{stake_address}
  @[inline] def byStake (stakeAddress : String) : BF (Except BFApiError BFStakeAddressInfo) :=
    Blockfrost.accounts.byStake stakeAddress |>.getJsonM (α := BFStakeAddressInfo)

  -- PAGINATION
  -- namespace byStake
  --   namespace history
  --     /-- GET /accounts/{stake}/history with optional pagination filters. -/
  --     def byStake (stake : String) (lp : ListParams := {}) : BF (Array BFAccountHistory) := do
  --       let p := Blockfrost.accounts.history stake |> Blockfrost.Typed.withParams lp
  --       p.getJsonM (α := Array BFAccountHistory)
  --   end history
  -- end byStake
end accounts

end Blockfrost.Typed
