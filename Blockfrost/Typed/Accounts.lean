import Blockfrost.Env
import Blockfrost.Path
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Common

namespace Blockfrost.Typed
open Blockfrost
open Blockfrost.Models

namespace accounts
  namespace byStake
    namespace history
      /-- GET /accounts/{stake}/history with optional pagination filters. -/
      def get (stake : String) (lp : ListParams := {}) : BF (Array BFAccountHistoryRow) := do
        let p := Blockfrost.accounts.byStake.history stake |> Blockfrost.Typed.withParams lp
        p.getJsonM (α := Array BFAccountHistoryRow)
    end history
  end byStake
end accounts

end Blockfrost.Typed
