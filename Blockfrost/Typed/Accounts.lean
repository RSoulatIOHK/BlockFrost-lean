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

  -- GET /accounts/{stake_address}/rewards
  @[inline] def rewards (stakeAddress : String) : BF (Except BFApiError (List BFReward)) :=
    Blockfrost.accounts.rewards stakeAddress |>.getJsonM (α := List BFReward)

  -- GET /accounts/{stake_address}/history
  @[inline] def history (stakeAddress : String) : BF (Except BFApiError (List BFAccountHistory)) :=
    Blockfrost.accounts.history stakeAddress |>.getJsonM (α := List BFAccountHistory)

  -- GET /accounts/{stake_address}/delegations
  @[inline] def delegations (stakeAddress : String) : BF (Except BFApiError (List BFAccountDelegation)) :=
    Blockfrost.accounts.delegations stakeAddress |>.getJsonM (α := List BFAccountDelegation)

  -- GET /accounts/{stake_address}/registrations
  @[inline] def registrations (stakeAddress : String) : BF (Except BFApiError (List BFAccountRegistration)) :=
    Blockfrost.accounts.registrations stakeAddress |>.getJsonM (α := List BFAccountRegistration)

  -- GET /accounts/{stake_address}/withdrawals
  @[inline] def withdrawals (stakeAddress : String) : BF (Except BFApiError (List BFAccountWithdrawal)) :=
    Blockfrost.accounts.withdrawals stakeAddress |>.getJsonM (α := List BFAccountWithdrawal)

  -- GET /accounts/{stake_address}/mirs
  @[inline] def mirs (stakeAddress : String) : BF (Except BFApiError (List BFAccountMIR)) :=
    Blockfrost.accounts.mirs stakeAddress |>.getJsonM (α := List BFAccountMIR)

  -- GET /accounts/{stake_address}/addresses
  @[inline] def addresses (stakeAddress : String) : BF (Except BFApiError (List BFAccountAddresses)) :=
    Blockfrost.accounts.addresses stakeAddress |>.getJsonM (α := List BFAccountAddresses)

  namespace addresses
    -- GET /accounts/{stake_address}/addresses/assets
    @[inline] def assets (stakeAddress : String) : BF (Except BFApiError (List BFAccountAssets)) :=
      Blockfrost.accounts.addresses.assets stakeAddress |>.getJsonM (α := List BFAccountAssets)

    -- GET /accounts/{stake_address}/addresses/total
    @[inline] def total (stakeAddress : String) : BF (Except BFApiError BFAddressDetailed) :=
      Blockfrost.accounts.addresses.total stakeAddress |>.getJsonM (α := BFAddressDetailed)
  end addresses
  -- GET /accounts/{stake_address}/utxos
  @[inline] def utxos (stakeAddress : String) : BF (Except BFApiError (List BFAddressUtxos)) :=
    Blockfrost.accounts.utxos stakeAddress |>.getJsonM (α := List BFAddressUtxos)

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
