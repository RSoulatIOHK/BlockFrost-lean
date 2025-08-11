import Blockfrost.Env
import Lean.Data.Json
import Lean.Data.Json.FromToJson

namespace Blockfrost

structure Path where
  segs : Array String := #[]
  qs   : Array (String × String) := #[]
deriving Repr

@[inline] def Path.seg (p : Path) (s : String) : Path := { p with segs := p.segs.push s }
@[inline] def Path.q   (p : Path) (k v : String) : Path := { p with qs := p.qs.push (k, v) }

/-- Finalizers that *use* the BF monad (no explicit client arg). -/
def Path.getStringM (p : Path) : BF String :=
  Blockfrost.getStringM p.segs p.qs

def Path.getJsonM [Lean.FromJson α] (p : Path) : BF α :=
  Blockfrost.getJsonM (α := α) p.segs p.qs

end Blockfrost
