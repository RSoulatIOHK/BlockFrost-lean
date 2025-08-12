import Lean.Data.Json
-- import Blockfrost.Models.Common
import Lean.Data.Json.FromToJson
import Blockfrost.Models.Derive

namespace Blockfrost

-- GET /pools
abbrev BFPoolListElem := String

-- GET /pools/extended
structure BFPoolMetadata where
  url? : Option String := none
  hash? : Option String := none
  ticker? : Option String := none
  name? : Option String := none
  description? : Option String := none
  homepage? : Option String := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFPoolMetadata where

structure BFPoolExtended where
  pool_id : String
  hex : String
  active_stake : String
  live_stake : String
  live_saturation : Nat
  blocks_minted : Int
  declared_pledge : String
  margin_cost : Nat
  fixed_cost : String
  metadata : BFPoolMetadata
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFPoolExtended where

-- GET /pools/retired /pools/retiring
structure BFPoolRetired where
  pool_id : String
  epoch : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFPoolRetired where

-- GET /pools/{pool_id}
structure BFCalidusKey where
  id : String
  pub_key : String
  nonce : Int
  tx_hash : String
  block_height : Int
  block_time : Int
  epoch : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFCalidusKey where

structure BFPoolInfo where
  pool_id : String
  hex : String
  vrf_key : String
  blocks_minted : Int
  blocks_epoch : Int
  live_stake : String
  live_size : Nat
  live_saturation : Nat
  live_delegators : Nat
  active_stake : String
  active_size : Nat
  declared_pledge : String
  live_pledge : String
  margin_cost : Nat
  fixed_cost : String
  reward_account : String
  owners : List String
  registration : List String
  retirement : List String
  calidus_key? : Option BFCalidusKey := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFPoolInfo where

-- GET /pools/{pool_id}/history
structure BFPoolHistory where
  epoch : Int
  blocks : Int
  active_stake : String
  active_size : String
  delegators_count : Int
  rewards : String
  fees : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFPoolHistory where

-- GET /pools/{pool_id}/metadata
abbrev BFPoolMetadataInfo := Lean.Json
instance : PrettyToString BFPoolMetadataInfo where

-- GET /pools/{pool_id}/relays
structure BFPoolRelay where
  ipv4? : Option String := none
  ipv6? : Option String := none
  dns? : Option String := none
  dns_srv? : Option String := none
  port : Int
deriving Repr, Lean.FromJson, Lean.ToJson

-- GET /pools/{pool_id}/delegators
structure BFPoolDelegator where
  address : String
  live_stake : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFPoolDelegator where

-- GET /pools/{pool_id}/blocks
abbrev BFPoolBlock := String

-- GET /pools/{pool_id}/updates
structure BFPoolUpdate where
  tx_hash : String
  cert_index : Int
  action : String -- TODO: enum?
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFPoolUpdate where

-- GET /pools/{pool_id}/votes
structure BFPoolVote where
  tx_hash : String
  cert_index : Int
  vote : String -- TODO: enum?
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFPoolVote where
