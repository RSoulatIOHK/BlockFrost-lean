import Lean.Data.Json
import Blockfrost.Models.Derive

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

instance : PrettyToString BFStakeAddressInfo where

structure BFAccountRewardHistoryRow where
  epoch        : Int
  amount       : String
  pool_id      : String
  type         : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAccountRewardHistoryRow where

structure BFAccountHistory where
  active_epoch : Int
  amount : String
  pool_id : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAccountHistory where

structure BFAccountDelegation where
  active_epoch : Int
  tx_hash : String
  amount : String
  pool_id : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAccountDelegation where

structure BFAccountRegistration where
  tx_hash : String
  action : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAccountRegistration where

structure BFAccountWithdrawal where
  tx_hash : String
  amount : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAccountWithdrawal where

structure BFAccountMIR where
  tx_hash : String
  amount : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAccountMIR where

structure BFAccountAddresses where
  address : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAccountAddresses where

structure BFAccountAssets where
  unit : String
  quantity : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAccountAssets where

structure BFAddressDetailed where
  stake_address : String
  received_sum : Array BFAccountAssets
  sent_sum : Array BFAccountAssets
  tx_count : Int
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAddressDetailed where

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

instance : PrettyToString BFAddressUtxos where

structure BFReward where
  epoch : Nat
  amount : String
  pool_id :  String
  type : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFReward where

end  Blockfrost
