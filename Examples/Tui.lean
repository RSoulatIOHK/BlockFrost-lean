import Std

namespace Examples.Tui

open Std

/-! ANSI helpers. -/
namespace Ansi
  def esc := "\x1b["
  def clearScreen   := s!"{esc}2J"
  def hideCursor    := s!"{esc}?25l"
  def showCursor    := s!"{esc}?25h"
  def reset         := s!"{esc}0m"
  def bold          := s!"{esc}1m"
  def dim           := s!"{esc}2m"
  def fgGreen       := s!"{esc}32m"
  def fgRed         := s!"{esc}31m"
  def fgCyan        := s!"{esc}36m"
  def fgYellow      := s!"{esc}33m"
  def fgGray        := s!"{esc}90m"
  def goto (row col : Nat) := s!"{esc}{row};{col}H"
  def clearToEnd  := s!"{esc}0J"
  def wrapOff     := s!"{esc}?7l"
  def wrapOn      := s!"{esc}?7h"
  def underline   := s!"{esc}4m"
end Ansi

/-- Small string helpers Lean4 is missing. -/
@[inline] def repeatStr (s : String) (n : Nat) : String :=
  String.join (List.replicate n s)

@[inline] def takeLeft (s : String) (n : Nat) : String :=
  if s.length ≤ n then s else String.mk <| (s.data.take n)

@[inline] def takeRight {α} (a : Array α) (k : Nat) : Array α :=
  if a.size ≤ k then a else a.extract (a.size - k) a.size

@[inline] def fit (n : Nat) (s : String) : String :=
  let s' := takeLeft s n
  s' ++ repeatStr " " (n - s'.length)

/-- Data we render. -/
structure BlockCell where
  hash   : String
  height : Option Int
deriving Inhabited

structure ScriptRow where
  hash   : String
  ok     : Bool
deriving Inhabited

structure Model where
  blocks      : Array BlockCell := #[]
  goodScripts : Array String    := #[]
  badScripts  : Array String    := #[]
  badBlocks   : Std.HashSet String := {}
  pending     : Std.HashSet String := {}  -- NEW
  maxBlocks   : Nat := 200
  maxScripts  : Nat := 10
deriving Inhabited

@[inline] def cellColor (bad : Bool) : String :=
  if bad then Ansi.fgRed else Ansi.fgGreen

def trimHash (h : String) (n := 8) : String :=
  takeLeft h n

def ppHeight (h? : Option Int) : String :=
  match h? with
  | some h => toString h
  | none   => "?"

def renderHeader (cols : Nat) : String :=
  let title := s!"{Ansi.bold}{Ansi.fgCyan}UPLC Script Scanner{Ansi.reset}  {Ansi.dim}{Ansi.fgGray}(live){Ansi.reset}"
  title ++ "\n" ++ repeatStr "-" cols

@[inline] def clampWidth (cols : Nat) (s : String) : String :=
  -- ensure each line is <= cols and pad to exactly cols (no wrap)
  let lines := s.splitOn "\n"
  let fix (l : String) :=
    let l' := takeLeft l cols
    l' ++ repeatStr " " (cols - l'.length)
  String.intercalate "\n" (lines.map fix)

@[inline] def clampAndPadHeight (rows : Nat) (frame : String) : String :=
  -- ensure total lines is <= rows and pad with blanks to exactly rows
  let lines := frame.splitOn "\n"
  let need  := if lines.length ≥ rows then rows else rows
  let cut   := lines.take need
  let padded :=
    if cut.length < rows then
      cut ++ List.replicate (rows - cut.length) ""
    else cut
  String.intercalate "\n" padded

def termSize : IO (Nat × Nat) := do
  let out ← IO.Process.output { cmd := "sh", args := #["-c", "stty size < /dev/tty 2>/dev/null || echo 24 100"] }
  let xs := out.stdout.trim.splitOn " "
  let r  := xs.getD 0 "24" |>.toNat!
  let c  := xs.getD 1 "100" |>.toNat!
  pure (r, c)

@[inline] def center (w : Nat) (s : String) : String :=
  let s'  := takeLeft s (min w s.length)
  let rem := w - s'.length
  let l   := rem / 2
  let r   := rem - l
  repeatStr " " l ++ s' ++ repeatStr " " r

def renderBlocks (m : Model) (cols : Nat) : String := Id.run do
  let cellW   := 4                           -- widen for more spacing
  let cap     := max 1 (cols / cellW)        -- cells that fit across the terminal
  let shown   := takeRight m.blocks cap
  let pad     := cap - shown.size            -- left pad so newest sits at far right
  let padCell := repeatStr " " cellW
  let base    := Ansi.dim ++ Ansi.fgGray

  let mut l1  := repeatStr padCell pad       -- colored glyphs row
  let mut l2  := repeatStr padCell pad       -- base bar row
  let mut l3  := repeatStr padCell pad       -- centered 2-char label row

  for b in shown do
    let color :=
      if m.pending.contains b.hash then Ansi.fgYellow
      else if m.badBlocks.contains b.hash then Ansi.fgRed
      else Ansi.fgGreen
    l1 := l1 ++ color ++ "▉" ++ repeatStr " " (cellW - 1) ++ Ansi.reset
    l2 := l2 ++ base ++ repeatStr "─" cellW ++ Ansi.reset
    l3 := l3 ++ base ++ center cellW (trimHash b.hash 2) ++ Ansi.reset

  s!"{l1}\n{l2}\n{l3}"

@[inline] def spaces (n : Nat) : String := repeatStr " " n

/-- one row inside a column; `ok = true` for ✓, false for ✗ CEX. -/
def colLine (ok : Bool) (hash : String) (colW : Nat) : String :=
  let markW  := 5                                 -- fixed field for the mark
  let textW  := if colW > markW + 1 then colW - markW - 1 else 0
  let markPlain := if ok then "✓" else "✗ CEX"    -- visible text only
  let markColor := if ok then Ansi.fgGreen else Ansi.fgRed
  let markField := markColor ++ markPlain ++ Ansi.reset ++ spaces (markW - markPlain.length)
  let htrim     := takeLeft hash (min 16 textW)
  let hashField := htrim ++ spaces (textW - htrim.length)
  markField ++ " " ++ hashField                   -- total visible width = colW

/-- two-column renderer (failed left, valid right), ANSI-safe. -/
def renderScripts (m : Model) (cols : Nat := 100) : String := Id.run do
  let hdr := s!"{Ansi.bold}Recent scripts{Ansi.reset}"

  -- newest-first in each column, independently capped
  let failed := (takeRight m.badScripts  m.maxScripts).toList.reverse
  let valid  := (takeRight m.goodScripts m.maxScripts).toList.reverse

  let gutter := "   "
  let colW   := (cols - gutter.length) / 2

  -- headers (pad using plain text width)
  let leftHdrPlain  := "Failed scripts"
  let rightHdrPlain := "Valid scripts"
  let leftHdr  := Ansi.underline ++ leftHdrPlain  ++ Ansi.reset ++ spaces (colW - leftHdrPlain.length)
  let rightHdr := Ansi.underline ++ rightHdrPlain ++ Ansi.reset ++ spaces (colW - rightHdrPlain.length)

  let mut body := leftHdr ++ gutter ++ rightHdr ++ "\n"

  let rows := Nat.max failed.length valid.length
  for i in [:rows] do
    let left  :=
      match failed.get? i with
      | some h => colLine false h colW
      | none   => spaces colW
    let right :=
      match valid.get? i with
      | some h => colLine true  h colW
      | none   => spaces colW
    body := body ++ left ++ gutter ++ right ++ "\n"

  hdr ++ "\n" ++ body

def fullRender (m : Model) (_rows cols : Nat) : String :=
  let totalScripts := m.goodScripts.size + m.badScripts.size
  String.intercalate "\n"
    [ renderHeader cols
    , renderBlocks m cols
    , repeatStr "-" cols
    , renderScripts m cols
    , repeatStr "-" cols
    , s!"{Ansi.dim}blocks={m.blocks.size}  scripts={totalScripts}   (Ctrl+C to quit){Ansi.reset}"
    ]

/-- Simple parity predicate: last hex nibble even → ok. -/
def parityOk (hexHash : String) (natParam : Nat := 2): Bool :=
  match hexHash.data.getLast? with
  | none   => true
  | some c =>
    let v :=
      if '0' ≤ c ∧ c ≤ '9' then c.val - '0'.val
      else if 'a' ≤ c ∧ c ≤ 'f' then 10 + (c.val - 'a'.val)
      else if 'A' ≤ c ∧ c ≤ 'F' then 10 + (c.val - 'A'.val)
      else 0
    not ((v % natParam) == 0)

/-- “Bus” you hold in your app to push events. -/
structure Bus where
  model : IO.Ref Model

def markBlockVerdict (bus : Bus) (hash : String) (isBad : Bool) : IO Unit := do
  _ ← bus.model.modifyGet (fun m =>
    let bad' := if isBad then m.badBlocks.insert hash else m.badBlocks.erase hash
    ((), { m with badBlocks := bad', pending := m.pending.erase hash })
  )

def onNewBlock (bus : Bus) (hash : String) (height : Option Int) : IO Unit := do
  _ ← bus.model.modifyGet (fun m =>
    let b := { hash, height }
    let arr := takeRight (m.blocks.push b) m.maxBlocks
    ((), { m with blocks := arr, pending := m.pending.insert hash })
  )

def onNewScript (bus : Bus) (hash : String) : IO Unit := do
  let ok := parityOk hash  -- or your custom rule
  _ ← bus.model.modifyGet (fun m =>
    let good :=
      if ok then takeRight (m.goodScripts.push hash) m.maxScripts else m.goodScripts
    let bad  :=
      if ok then m.badScripts else takeRight (m.badScripts.push hash) m.maxScripts
    ((), { m with goodScripts := good, badScripts := bad })
  )
  pure ()

/-- Full-screen repaint loop (no scrolling). -/
partial def runUi (bus : Bus) (tickMs : Nat := 120) : IO Unit := do
  let (rows, cols) ← termSize
  let stdout ← IO.getStdout
  stdout.putStr (Ansi.hideCursor ++ Ansi.wrapOff ++ Ansi.clearScreen)
  let rec loop : IO Unit := do
    let m ← bus.model.get
    stdout.putStr (Ansi.goto 1 1)
    let raw   := fullRender m rows cols
    let fixed := clampAndPadHeight rows raw
    stdout.putStr fixed
    stdout.putStr Ansi.clearToEnd
    stdout.flush
    IO.sleep tickMs.toUInt32
    loop
  try loop
  finally stdout.putStr (Ansi.wrapOn ++ Ansi.showCursor)


end Examples.Tui
