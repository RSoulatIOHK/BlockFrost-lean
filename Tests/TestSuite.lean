-- Tests/TestSuite.lean
import Blockfrost.Env
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Typed

open Blockfrost
open Blockfrost.BF
open Blockfrost.Models

-- Test configuration
structure TestConfig where
  stakeAddress : String := "stake1u9ylzsgxaa6xctf4juup682ar3juj85n8tx3hthnljg47zctvm3rc"
  addressForTest : String := "addr1qxqs59lphg8g6qndelq8xwqn60ag3aeyfcp33c2kdp46a09re5df3pzwwmyq946axfcejy5n4x0y99wqpgtp2gd0k09qsgy6pz"
  assetForTest : String := "b863bc7369f46136ac1048adb2fa7dae3af944c3bbb2be2f216a8d4f426572727953616765"
  poolId : String := "pool1pu5jlj4q9w9jlxeu370a3c9myx47md5j5m2str0naunn2q3lkdy"
  txHash : String := "f22edbf2bbe1157b8a08d35db65c3bfff5edeb769fa9bf6a73fe01aa2a10d87b"
  scriptHash : String := "65c197d565e88a20885e535f93755682444d3c02fd44dd70883fe89e"
  datumHash : String := "db583ad85881a96c73fbb26ab9e24d1120bb38f45385664bb9c797a2ea8d9a2d"

-- Test result type
inductive TestResult where
  | success (name : String) (message : String := "")
  | failure (name : String) (error : String)
  | skipped (name : String) (reason : String)

instance : ToString TestResult where
  toString
  | .success name msg => s!"✅ {name}" ++ (if msg.isEmpty then "" else s!" - {msg}")
  | .failure name err => s!"❌ {name} - {err}"
  | .skipped name reason => s!"⏭️ {name} - {reason}"

-- Helper to run a test and catch errors
def runTest (name : String) (test : BF α) : BF TestResult := do
  try
    let _ ← test
    return TestResult.success name
  catch
  | BFError.api status err msg => return TestResult.failure name s!"API Error {status}: {err} - {msg}"
  | BFError.network msg => return TestResult.failure name s!"Network Error: {msg}"
  | BFError.parse msg _ => return TestResult.failure name s!"Parse Error: {msg}"
  | BFError.decode msg _ => return TestResult.failure name s!"Decode Error: {msg}"

-- Test helper for endpoints that might be empty/unavailable
def runTestOptional (name : String) (test : BF (Except BFApiError α)) : BF TestResult := do
  try
    let result ← test
    match result with
    | .ok _ => return TestResult.success name
    | .error apiError =>
      if apiError.status_code == 404 then
        return TestResult.skipped name "No data available"
      else
        return TestResult.failure name s!"API Error {apiError.status_code}: {apiError.error}"
  catch e =>
    return TestResult.failure name s!"Exception: {e}"

-- Test suites
namespace Tests

def testAccounts (config : TestConfig) : BF (List TestResult) := do
  IO.println "🔍 Testing Accounts endpoints..."
  let tests := [
    ("accounts.byStake", runTestOptional "GET /accounts/{stake_address}"
      (Blockfrost.Typed.accounts.byStake config.stakeAddress)),
    ("accounts.rewards", runTestOptional "GET /accounts/{stake_address}/rewards"
      (Blockfrost.Typed.accounts.rewards config.stakeAddress)),
    ("accounts.history", runTestOptional "GET /accounts/{stake_address}/history"
      (Blockfrost.Typed.accounts.history config.stakeAddress)),
    ("accounts.delegations", runTestOptional "GET /accounts/{stake_address}/delegations"
      (Blockfrost.Typed.accounts.delegations config.stakeAddress)),
    ("accounts.addresses", runTestOptional "GET /accounts/{stake_address}/addresses"
      (Blockfrost.Typed.accounts.addresses config.stakeAddress))
  ]

  let results ← tests.mapM (fun (_, test) => test)
  return results

def testAddresses (config : TestConfig) : BF (List TestResult) := do
  IO.println "🏠 Testing Addresses endpoints..."
  let tests := [
    runTestOptional "GET /addresses/{address}"
      (Blockfrost.Typed.addresses.byAddress config.addressForTest),
    runTestOptional "GET /addresses/{address}/extended"
      (Blockfrost.Typed.addresses.extended config.addressForTest),
    runTestOptional "GET /addresses/{address}/total"
      (Blockfrost.Typed.addresses.total config.addressForTest),
    runTestOptional "GET /addresses/{address}/utxos"
      (Blockfrost.Typed.addresses.utxos config.addressForTest),
    runTestOptional "GET /addresses/{address}/transactions"
      (Blockfrost.Typed.addresses.transactions config.addressForTest)
  ]

  tests.mapM id

def testAssets (config : TestConfig) : BF (List TestResult) := do
  IO.println "💎 Testing Assets endpoints..."
  let tests := [
    runTestOptional "GET /assets"
      (Blockfrost.Typed.assets),
    runTestOptional "GET /assets/{asset}"
      (Blockfrost.Typed.assets.byAsset config.assetForTest),
    runTestOptional "GET /assets/{asset}/history"
      (Blockfrost.Typed.assets.history config.assetForTest),
    runTestOptional "GET /assets/{asset}/transactions"
      (Blockfrost.Typed.assets.transactions config.assetForTest),
    runTestOptional "GET /assets/{asset}/addresses"
      (Blockfrost.Typed.assets.addresses config.assetForTest)
  ]

  tests.mapM id

def testBlocks (config : TestConfig) : BF (List TestResult) := do
  IO.println "🧱 Testing Blocks endpoints..."
  let tests := [
    runTestOptional "GET /blocks/latest"
      (Blockfrost.Typed.blocks.latest),
    runTestOptional "GET /blocks/latest/txs"
      (Blockfrost.Typed.blocks.latest.txs),
    runTestOptional "GET /blocks/{hash_or_number}"
      (Blockfrost.Typed.blocks.byHash "500"),
    runTestOptional "GET /blocks/{hash_or_number}/next"
      (Blockfrost.Typed.blocks.next "500"),
    runTestOptional "GET /blocks/slot/{slot_number}"
      (Blockfrost.Typed.blocks.slot.bySlot 30895909)
  ]

  tests.mapM id

def testEpochs : BF (List TestResult) := do
  IO.println "📅 Testing Epochs endpoints..."
  let tests := [
    runTestOptional "GET /epochs/latest"
      (Blockfrost.Typed.epochs.latest),
    runTestOptional "GET /epochs/latest/parameters"
      (Blockfrost.Typed.epochs.latest.parameters),
    runTestOptional "GET /epochs/{epoch}"
      (Blockfrost.Typed.epochs.byEpoch 269),
    runTestOptional "GET /epochs/{epoch}/parameters"
      (Blockfrost.Typed.epochs.parameters 269)
  ]

  tests.mapM id

def testHealth : BF (List TestResult) := do
  IO.println "🏥 Testing Health endpoints..."
  let tests := [
    runTestOptional "GET /health"
      (Blockfrost.Typed.health),
    runTestOptional "GET /health/clock"
      (Blockfrost.Typed.health.clock)
  ]

  tests.mapM id

def testMempool : BF (List TestResult) := do
  IO.println "🔄 Testing Mempool endpoints..."
  let tests := [
    runTestOptional "GET /mempool"
      (Blockfrost.Typed.mempool)
  ]

  tests.mapM id

def testNetwork : BF (List TestResult) := do
  IO.println "🌐 Testing Network endpoints..."
  let tests := [
    runTestOptional "GET /network"
      (Blockfrost.Typed.network),
    runTestOptional "GET /network/eras"
      (Blockfrost.Typed.network.eras)
  ]

  tests.mapM id

def testPools (config : TestConfig) : BF (List TestResult) := do
  IO.println "🏊 Testing Pools endpoints..."
  let tests := [
    runTestOptional "GET /pools"
      (Blockfrost.Typed.pools),
    runTestOptional "GET /pools/{pool_id}"
      (Blockfrost.Typed.pools.byId config.poolId),
    runTestOptional "GET /pools/{pool_id}/history"
      (Blockfrost.Typed.pools.history config.poolId),
    runTestOptional "GET /pools/{pool_id}/metadata"
      (Blockfrost.Typed.pools.metadata config.poolId)
  ]

  tests.mapM id

def testTransactions (config : TestConfig) : BF (List TestResult) := do
  IO.println "📝 Testing Transactions endpoints..."
  let tests := [
    runTestOptional "GET /txs/{hash}"
      (Blockfrost.Typed.txs.byHash config.txHash),
    runTestOptional "GET /txs/{hash}/utxos"
      (Blockfrost.Typed.txs.utxos config.txHash),
    runTestOptional "GET /txs/{hash}/stakes"
      (Blockfrost.Typed.txs.stakes "6e5f825c82c1c6d6b77f2a14092f3b78c8f1b66db6f4cf8caec1555b6f967b3b"),
    runTestOptional "GET /txs/{hash}/metadata"
      (Blockfrost.Typed.txs.metadata config.txHash)
  ]

  tests.mapM id

-- Main test runner
def runAllTests (config : TestConfig) : BF (List TestResult) := do
  IO.println "🚀 Starting Blockfrost API Test Suite"
  IO.println "======================================"

  let allResults ← [
    testHealth,
    testNetwork,
    testAccounts config,
    testAddresses config,
    testAssets config,
    testBlocks config,
    testEpochs,
    testMempool,
    testPools config,
    testTransactions config
  ].foldlM (fun acc test => do
    let results ← test
    return acc ++ results
  ) []

  return allResults

-- Specific test suites
def runAccountTests (config : TestConfig) : BF Unit := do
  let results ← testAccounts config
  for result in results do
    IO.println result

def runHealthTests : BF Unit := do
  let results ← testHealth
  for result in results do
    IO.println result

def runNetworkTests : BF Unit := do
  let results ← testNetwork
  for result in results do
    IO.println result

end Tests

-- Print summary
def printSummary (results : List TestResult) : IO Unit := do
  let total := results.length

  -- Count each type properly
  let mut successes := 0
  let mut failures := 0
  let mut skipped := 0
  let mut failureList : List TestResult := []

  for result in results do
    match result with
    | .success _ _ => successes := successes + 1
    | .failure _ _ =>
      failures := failures + 1
      failureList := result :: failureList
    | .skipped _ _ => skipped := skipped + 1

  IO.println ""
  IO.println "📊 Test Summary"
  IO.println "==============="
  IO.println s!"Total: {total}"
  IO.println s!"✅ Passed: {successes}"
  IO.println s!"❌ Failed: {failures}"
  IO.println s!"⏭️ Skipped: {skipped}"

  if failures > 0 then
    IO.println ""
    IO.println "❌ Failures:"
    for result in failureList.reverse do
      IO.println s!"  {result}"

-- Main test function
def runTests : IO Unit := do
  let some pid ← IO.getEnv "BLOCKFROST_PROJECT_ID"
    | throw <| IO.userError "Set BLOCKFROST_PROJECT_ID"
  let env : Env := { base := "https://cardano-mainnet.blockfrost.io/api/v0", projectId := pid }
  let config : TestConfig := {}

  BF.run env do
    let results ← Tests.runAllTests config
    for result in results do
      IO.println result
    printSummary results
