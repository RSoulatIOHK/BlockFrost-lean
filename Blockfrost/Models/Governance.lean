import Lean.Data.Json
import Lean.Data.Json.FromToJson
import Blockfrost.Models.Common
import Blockfrost.Models.Derive
import Blockfrost.Models.Epochs

namespace Blockfrost

-- GET /governance/dreps
structure BFDRep where
  drep_id : String
  hex     : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFDRep where

-- GET /governance/dreps/{drep_id}
structure BFDRepInfo where
  drep_id : String
  hex     : String
  amount : String
  active? : Option Bool := none -- (deprecated)
  active_since? : Option Int := none -- (deprecated)
  has_script : Bool
  retired : Bool
  expired : Bool
  last_active_epoch? : Option Int := none
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFDRepInfo where

-- GET /governance/dreps/{drep_id}/delegators
structure BFDRepDelegator where
  address : String
  amount : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFDRepDelegator where

-- GET /governance/dreps/{drep_id}/metadata
structure BFDRepMetadata where
  drep_id : String
  hex : String
  url : String
  hash : String
  jsonMetadata : Lean.Json -- Any of several stuff
  bytes : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFDRepMetadata where

-- GET /governance/dreps/{drep_id}/updates
structure BFDRepUpdate where
  tx_hash : String
  cert_index : Int
  action : String -- TODO: Enum type?
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFDRepUpdate where

-- GET /governance/dreps/{drep_id}/votes
structure BFDRepVote where
  tx_hash : String
  cert_index : Int
  vote : String -- TODO: Enum type?
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFDRepVote where

-- GET /governance/proposals
structure BFProposal where
  tx_hash : String
  cert_index : Int
  governance_type : String -- TODO: Enum type?
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFProposal where

-- GET /governance/proposals/{tx_hash}/{cert_index}
structure BFProposalInfo where
  tx_hash : String
  cert_index : Int
  governance_type : String -- TODO: Enum type?
  governance_description? : Option Lean.Json := none -- anything
  deposit : String
  return_address : String
  ratified_epoch? : Option Int := none
  enacted_epoch? : Option Int := none
  dropped_epoch? : Option Int := none
  expired_epoch? : Option Int := none
  expiration : Int
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFProposalInfo where

-- GET /governance/proposals/{tx_hash}/{cert_index}/parameters
structure BFProposalParameters where
  tx_hash : String
  cert_index : Int
  parameters : BFEpochParameters
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFProposalParameters where

-- GET /governance/proposals/{tx_hash}/{cert_index}/withdrawals
structure BFProposalWithdrawal where
  stake_address : String
  amount : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFProposalWithdrawal where

-- GET /governance/proposals/{tx_hash}/{cert_index}/votes
structure BFProposalVote where
  tx_hash : String
  cert_index : Int
  voter_role : String -- TODO: Enum type?
  voter : String
  vote : String -- TODO: Enum type?
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFProposalVote where

-- GET /governance/proposals/{tx_hash}/{cert_index}/metadata
structure BFProposalMetadata where
  tx_hash : String
  cert_index : Int
  url : String
  hash : String
  jsonMetadata : Lean.Json -- Any of several stuff
  bytes : String
deriving Repr, Lean.FromJson, Lean.ToJson
instance : PrettyToString BFProposalMetadata where
