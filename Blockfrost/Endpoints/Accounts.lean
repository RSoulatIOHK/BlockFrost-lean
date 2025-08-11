import Blockfrost.Path
import Blockfrost.Endpoints.Root

namespace Blockfrost

namespace accounts
  @[inline] def byStake (stake : String) : Path :=
    root.seg "accounts" |>.seg stake

  namespace byStake
    @[inline] def history (stake : String) : Path :=
      accounts.byStake stake |>.seg "history"
  end byStake
end accounts

end Blockfrost
