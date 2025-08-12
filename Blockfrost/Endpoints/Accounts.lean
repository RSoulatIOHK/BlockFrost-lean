import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost

namespace accounts
  -- GET /accounts/{stake_address}
  @[inline] def byStake (stake : String) : Path :=
    root.seg "accounts" |>.seg stake

  -- GET /accounts/{stake_address}/rewards
  @[inline] def rewards (stake : String) : Path :=
    byStake stake |>.seg "rewards"

  -- GET /accounts/{stake_address}/history
  @[inline] def history (stake : String) : Path :=
    byStake stake |>.seg "history"

  -- GET /accounts/{stake_address}/delegations
  @[inline] def delegations (stake : String) : Path :=
    byStake stake |>.seg "delegations"

  -- GET /accounts/{stake_address}/registrations
  @[inline] def registrations (stake : String) : Path :=
    byStake stake |>.seg "registrations"

  -- GET /accounts/{stake_address}/withdrawals
  @[inline] def withdrawals (stake : String) : Path :=
    byStake stake |>.seg "withdrawals"

  -- GET /accounts/{stake_address}/mirs
  @[inline] def mirs (stake : String) : Path :=
    byStake stake |>.seg "mirs"

  -- GET /accounts/{stake_address}/addresses
  @[inline] def addresses (stake : String) : Path :=
    byStake stake |>.seg "addresses"

  namespace addresses
    -- GET /accounts/{stake_address}/addresses/assets
    @[inline] def assets (stake : String) : Path :=
      byStake stake |>.seg "addresses" |>.seg "assets"

    -- GET /accounts/{stake_address}/addresses/total
    @[inline] def total (stake : String) : Path :=
      byStake stake |>.seg "addresses" |>.seg "total"
  end addresses

  -- GET /accounts/{stake_address}/utxos
  @[inline] def utxos (stake : String) : Path :=
    byStake stake |>.seg "utxos"

end accounts

end Blockfrost
