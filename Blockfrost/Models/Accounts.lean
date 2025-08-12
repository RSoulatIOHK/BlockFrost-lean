import Lean.Data.Json
import Lean.Data.Json.FromToJson

namespace Blockfrost

structure BFStakeAddressInfo where
  stake_address : String
  active : Bool
  active_epoch? : Option Int := none
  controlled_amount : String
  rewards_sum : String
  withdrawals_sum : String
  reserves_sum : String
  treasury_sum : String
  withdrawable_amount : String
  pool_id? : Option String := none
  drep_id? : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFStakeAddressInfo where
  toString (s : BFStakeAddressInfo) :=
    s!"{s.stake_address} (active: {s.active}, controlled: {s.controlled_amount}, rewards: {s.rewards_sum}, withdrawals: {s.withdrawals_sum}, reserves: {s.reserves_sum}, treasury: {s.treasury_sum}, pool: {s.pool_id?}, drep: {s.drep_id?})"

structure BFAccountRewardHistoryRow where
  epoch        : Int
  amount       : String
  pool_id      : String
  type         : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAccountRewardHistoryRow where
  toString (r : BFAccountRewardHistoryRow) := s!"{r.epoch} {r.amount} (pool: {r.pool_id}, type: {r.type})"

structure BFAccountHistory where
  active_epoch : Int
  amount : String
  pool_id : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAccountHistory where
  toString (h : BFAccountHistory) := s!"{h.active_epoch} {h.amount} (pool: {h.pool_id})"

structure BFAccountDelegation where
  active_epoch : Int
  tx_hash : String
  amount : String
  pool_id : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAccountDelegation where
  toString (d : BFAccountDelegation) := s!"{d.active_epoch} {d.amount} (tx: {d.tx_hash}, pool: {d.pool_id})"

structure BFAccountRegistration where
  tx_hash : String
  action : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAccountRegistration where
  toString (r : BFAccountRegistration) := s!"{r.tx_hash} ({r.action})"

structure BFAccountWithdrawal where
  tx_hash : String
  amount : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAccountWithdrawal where
  toString (w : BFAccountWithdrawal) := s!"{w.tx_hash} {w.amount}"

structure BFAccountMIR where
  tx_hash : String
  amount : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAccountMIR where
  toString (m : BFAccountMIR) := s!"{m.tx_hash} {m.amount}"

structure BFAccountAddresses where
  address : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAccountAddresses where
  toString (a : BFAccountAddresses) := s!"{a.address}"

structure BFAccountAssets where
  unit : String
  quantity : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAccountAssets where
  toString (a : BFAccountAssets) := s!"{a.unit} {a.quantity}"

structure BFAddressDetailed where
  stake_address : String
  received_sum : Array BFAccountAssets
  sent_sum : Array BFAccountAssets
  tx_count : Int
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAddressDetailed where
  toString (a : BFAddressDetailed) :=
    s!"{a.stake_address} (received: {a.received_sum}, sent: {a.sent_sum}, tx count: {a.tx_count})"

structure BFAddressUtxos where
  address : String
  tx_hash : String
  tx_index? : Option Int := none -- (deprecated)
  output_index : Int
  amount : Array BFAccountAssets
  block : String
  data_hash? : Option String := none
  inlined_datum? : Option String := none
  reference_script_hash? : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFAddressUtxos where
  toString (u : BFAddressUtxos) :=
    s!"{u.address} {u.tx_hash} (index: {u.output_index}, amount: {u.amount}, block: {u.block}, data_hash: {u.data_hash?}, inlined_datum: {u.inlined_datum?}, reference_script_hash: {u.reference_script_hash?})"


structure BFReward where
  epoch : Nat
  amount : String
  pool_id :  String
  type : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : ToString BFReward where
  toString (r : BFReward) := s!"{r.epoch} {r.amount} (pool: {r.pool_id}, type: {r.type})"

end  Blockfrost
