import Lean.Data.Json
import Blockfrost.Models.Derive

namespace Blockfrost

structure BFUtxoAmount where
  unit     : String
  quantity : String
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFUtxoAmount where

/-- GET /addresses/{address} -/
structure BFAddressInfo where
  address : String
  amount  : List BFUtxoAmount
  stake_address? : Option String := none
  type : String -- TODO: Enum type?
  script : Bool
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAddressInfo where

instance : PrettyToString BFAddressInfo where
-- GET /addresses/{address}/extended
structure BFUtxoAmountExtended where
  unit     : String
  quantity : String
  decimals? : Option Int := none
  has_nft_onchain_metadata : Bool
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFUtxoAmountExtended where

structure BFAddressExtended where
  address : String
  amount : List BFUtxoAmountExtended
  stake_address? : Option String := none
  type : String -- TODO: Enum type?
  script : Bool
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAddressExtended where

-- GET /addresses/{address}/total
structure BFAddressTotal where
  address : String
  received_sum : List BFUtxoAmount
  sent_sum : List BFUtxoAmount
  tx_count : Int
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFAddressTotal where

/-- GET /addresses/{address}/utxos /addresses/{address}/utxos/{asset} -/
structure BFUtxo where
  address        : String
  tx_hash        : String
  tx_index       : Option Int := none -- (deprecated)
  output_index   : Int
  amount         : List BFUtxoAmount
  block          : String
  data_hash?     : Option String := none
  inline_datum?  : Option String := none
  reference_script_hash? : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFUtxo where

-- GET /addresses/{address}/txs (deprecated)
abbrev BFAddressTxs := String

instance : PrettyToString BFAddressTxs where

-- GET /addresses/{address}/transactions
structure BFAddressTransactions where
  tx_hash : String
  tx_index : Int
  block_height : Int
  block_time : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFAddressTransactions where

end Blockfrost
