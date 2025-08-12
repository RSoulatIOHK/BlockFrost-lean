import Lean.Data.Json
import Lean.Data.Json.FromToJson
import Blockfrost.Models.Common
import Blockfrost.Models.Derive

namespace Blockfrost
/-- GET /epochs/latest, /epochs/{epoch}(/next, /previous) -/
structure BFEpoch where
  epoch            : Nat
  start_time       : Nat
  end_time         : Nat
  first_block_time : Nat
  last_block_time  : Nat
  block_count      : Nat
  tx_count         : Nat
  output           : String
  fees             : String
  active_stake?    : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFEpoch where

/-- Cost models are language→cost-table maps; until you need a typed table,
treat them as JSON blobs. -/

structure BFCostModels where
  plutus_v1? : Option Lean.Json := none
  plutus_v2? : Option Lean.Json := none
  plutus_v3? : Option Lean.Json := none
deriving Repr, Lean.FromJson, Lean.ToJson

instance : PrettyToString BFCostModels where

-- GET /epochs/latest/parameters, /epochs/{epoch}/parameters
structure BFEpochParameters where
  epoch        : Int
  min_fee_a    : Int
  min_fee_b    : Int
  max_block_size : Int
  max_tx_size    : Int
  max_block_header_size : Int
  key_deposit  : String
  pool_deposit : String
  e_max        : Int
  n_opt        : Int
  a0           : Float
  rho          : Float
  tau          : Float
  decentralisation_param : Float
  extra_entropy : Option String := none
  protocol_major_ver : Int
  protocol_minor_ver : Int

  min_utxo? : Option String := none -- (deprecated)

  min_pool_cost : String
  nonce : String
  cost_models : BFCostModels
  cost_models_raw : Lean.Json
  price_mem : Option Float := none
  price_step : Option Float := none
  max_tx_ex_mem : Option String := none
  max_tx_ex_steps : Option String := none
  max_block_ex_mem : Option String := none
  max_block_ex_steps : Option String := none
  max_val_size : Option String := none
  collateral_percent : Option Int := none
  max_collateral_inputs : Option Int := none
  coins_per_utxo_size : Option String := none

  coins_per_utxo_word? : Option String := none -- (deprecated)

  pvt_motion_no_confidence : Option Float := none
  pvt_committee_normal : Option Float := none
  pvt_committee_no_confidence : Option Float := none
  pvt_hard_fork_initiation : Option Float := none
  dvt_committee_normal : Option Float := none
  dvt_committee_no_confidence : Option Float := none
  dvt_update_to_constitution : Option Float := none
  dvt_hard_fork_initiation : Option Float := none
  dvt_p_p_network_group : Option Float := none
  dvt_p_p_economic_group : Option Float := none
  dvt_p_p_technical_group : Option Float := none
  dvt_p_p_gov_group : Option Float := none
  dvt_treasury_withdrawal : Option Float := none
  committee_min_size : Option String := none
  committee_max_term_length : Option String := none
  gov_action_lifetime : Option String := none
  gov_action_deposit : Option String := none
  drep_deposit : Option String := none
  drep_activity : Option String := none
  -- pvt_pp_security_group : Nat -- DEPRECATED := none
  pvt_p_p_security_group : Option Float := none
  min_fee_ref_script_cost_per_byte : Option Float := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFEpochParameters where

-- GET /epochs/{number}/stakes
structure BFEpochStake where
  stake_address : String
  pool_id       : String
  amount        : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFEpochStake where

-- GET /epochs/{number}/stakes/{pool_id} /epochs/{number}/blocks(/{pool_id})
structure BFEpochStakeAmount where
  stake_address : String
  amount       : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFEpochStakeAmount where

-- GET /epochs/{number}/blocks
abbrev BFEpochBlock := String
end Blockfrost
