namespace Blockfrost.Utils

def plural (n : Nat):=
  if n == 1 then "" else "s"

/-- Handy helper if you want raw bytes from a hex CBOR string. -/
def hexToBytes (hex : String) : Except String ByteArray := Id.run do
  if hex.length % 2 != 0 then return .error "hex length must be even"
  let hexVal (c : Char) : Option UInt8 :=
    if '0' ≤ c ∧ c ≤ '9' then some (UInt8.ofNat (c.toNat - '0'.toNat))
    else if 'a' ≤ c ∧ c ≤ 'f' then some (UInt8.ofNat (10 + c.toNat - 'a'.toNat))
    else if 'A' ≤ c ∧ c ≤ 'F' then some (UInt8.ofNat (10 + c.toNat - 'A'.toNat))
    else none
  let rec loop (i : Nat) (acc : ByteArray) :=
    if h : i + 1 < hex.length then
      let hi := hex.get ⟨i⟩
      let lo := hex.get ⟨i+1⟩
      match hexVal hi, hexVal lo with
      | some a, some b =>
        let byte := (a.toNat <<< 4) + b.toNat
        loop (i+2) (acc.push (UInt8.ofNat byte))
      | _, _ => .error s!"invalid hex at pos {i}"
    else
      .ok acc
  loop 0 ByteArray.empty

end Blockfrost.Utils
