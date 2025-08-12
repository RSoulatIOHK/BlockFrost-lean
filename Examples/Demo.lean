import Blockfrost.Env
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Typed

open Blockfrost
open Blockfrost.BF
open Blockfrost.Models

-- Helper to print results nicely
def printResult [ToString α] (name : String) (result : Except BFApiError α) : IO Unit :=
  match result with
  | .error apiError => IO.println s!"{name}: ❌ {apiError.error} - {apiError.message}"
  | .ok value => IO.println s!"{name}: ✅ {value}"

-- Example: Get network info
def exampleNetworkInfo : BF Unit := do
  IO.println "📡 Getting network information..."
  let networkInfo ← Blockfrost.Typed.network
  printResult "Network" networkInfo

-- Example: Get latest block
def exampleLatestBlock : BF Unit := do
  IO.println "🧱 Getting latest block..."
  let latestBlock ← Blockfrost.Typed.blocks.latest
  printResult "Latest Block" latestBlock

-- Example: Get account info
def exampleAccountInfo (stakeAddress : String) : BF Unit := do
  IO.println s!"👤 Getting account info for {stakeAddress}..."
  let account ← Blockfrost.Typed.accounts.byStake stakeAddress
  printResult "Account" account

-- Example: Get address UTXOs
def exampleAddressUtxos (address : String) : BF Unit := do
  IO.println s!"💰 Getting UTXOs for {address}..."
  let utxos ← Blockfrost.Typed.addresses.utxos address
  match utxos with
  | .error apiError => IO.println s!"❌ {apiError.error} - {apiError.message}"
  | .ok utxoList =>
    IO.println s!"✅ Found {utxoList.length} UTXOs"
    for utxo in utxoList.take 3 do -- Show first 3
      IO.println s!"  UTXO: {utxo.tx_hash}#{utxo.output_index}"

-- Example: Get asset information
def exampleAssetInfo (asset : String) : BF Unit := do
  IO.println s!"💎 Getting asset info for {asset}..."
  let assetInfo ← Blockfrost.Typed.assets.byAsset asset
  printResult "Asset" assetInfo

-- Example: Get transaction details
def exampleTransactionInfo (txHash : String) : BF Unit := do
  IO.println s!"📝 Getting transaction info for {txHash}..."
  let txInfo ← Blockfrost.Typed.txs.byHash txHash
  printResult "Transaction" txInfo

  -- Also get UTXOs for this transaction
  let txUtxos ← Blockfrost.Typed.txs.utxos txHash
  match txUtxos with
  | .error _ => IO.println "  No UTXO info available"
  | .ok utxoInfo =>
    IO.println s!"  Inputs: {utxoInfo.inputs.size}, Outputs: {utxoInfo.outputs.size}"

-- Example: Search for pools
def examplePools : BF Unit := do
  IO.println "🏊 Getting pool list..."
  let pools ← Blockfrost.Typed.pools
  match pools with
  | .error apiError => IO.println s!"❌ {apiError.error}"
  | .ok poolList =>
    IO.println s!"✅ Found {poolList.size} pools"
    for pool in poolList.take 5 do -- Show first 5
      IO.println s!"  Pool: {pool}"

-- Demo configuration
structure DemoConfig where
  stakeAddress : String := "stake1u9ylzsgxaa6xctf4juup682ar3juj85n8tx3hthnljg47zctvm3rc"
  address : String := "addr1qxqs59lphg8g6qndelq8xwqn60ag3aeyfcp33c2kdp46a09re5df3pzwwmyq946axfcejy5n4x0y99wqpgtp2gd0k09qsgy6pz"
  asset : String := "b863bc7369f46136ac1048adb2fa7dae3af944c3bbb2be2f216a8d4f426572727953616765"
  txHash : String := "f22edbf2bbe1157b8a08d35db65c3bfff5edeb769fa9bf6a73fe01aa2a10d87b"

-- Main demo function
def runDemo : IO Unit := do
  let some pid ← IO.getEnv "BLOCKFROST_PROJECT_ID"
    | throw <| IO.userError "Set BLOCKFROST_PROJECT_ID environment variable"
  let env : Env := { base := "https://cardano-mainnet.blockfrost.io/api/v0", projectId := pid }
  let config : DemoConfig := {}

  IO.println "🚀 Blockfrost SDK Demo"
  IO.println "======================"

  BF.run env do
    -- Run examples
    exampleNetworkInfo
    IO.println ""

    exampleLatestBlock
    IO.println ""

    exampleAccountInfo config.stakeAddress
    IO.println ""

    exampleAddressUtxos config.address
    IO.println ""

    exampleAssetInfo config.asset
    IO.println ""

    exampleTransactionInfo config.txHash
    IO.println ""

    examplePools
    IO.println ""

  IO.println "✨ Demo completed!"

-- Quick health check
def healthCheck : IO Unit := do
  let some pid ← IO.getEnv "BLOCKFROST_PROJECT_ID"
    | throw <| IO.userError "Set BLOCKFROST_PROJECT_ID environment variable"
  let env : Env := { base := "https://cardano-mainnet.blockfrost.io/api/v0", projectId := pid }

  BF.run env do
    IO.println "🏥 Health Check..."
    let health ← Blockfrost.Typed.health
    match health with
    | .error apiError =>
      IO.println s!"❌ API Health Check Failed: {apiError.message}"
    | .ok _ =>
      IO.println "✅ Blockfrost API is healthy"
