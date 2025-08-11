import Blockfrost.Path
namespace Blockfrost.Typed

/-- Standard list/pagination parameters used by many endpoints. -/
structure ListParams where
  count? : Option Nat := none   -- default 100
  page?  : Option Nat := none   -- default 1
  order? : Option String := none -- "asc" | "desc"
  from?  : Option Nat := none    -- endpoint-specific meaning (e.g., epoch)
  to?    : Option Nat := none
deriving Inhabited

def withParams (lp : ListParams) (p : Blockfrost.Path) : Blockfrost.Path :=
  let p := match lp.count? with | some v => p.q "count" (toString v) | none => p
  let p := match lp.page?  with | some v => p.q "page"  (toString v) | none => p
  let p := match lp.order? with | some v => p.q "order" v               | none => p
  let p := match lp.from?  with | some v => p.q "from"  (toString v)    | none => p
  let p := match lp.to?    with | some v => p.q "to"    (toString v)    | none => p
  p


end Blockfrost.Typed
