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
  addressForTest : String := "addr1q8hsff3uwtphx7dtya7unjwjwug52e5jvqp09je6pwqx8k4jvuxrw2x5rr7e258a33yzkrhhlrrc5ezvd2z7qtdq0gasme44c9"
  assetForTest : String := "02f8fb8ec5d4d607039faca9cf1e1382fac442877fce90beb8e7218147524f57"
  poolId : String := "pool1w7c2j0px43jmudhf48ezp7dy8j7904c9l3wc7809lhh2z026hch"
  txHash : String := "f22edbf2bbe1157b8a08d35db65c3bfff5edeb769fa9bf6a73fe01aa2a10d87b"
  txHashWithMetadata : String := "4fbc508044dd58217c0d9d3a368c373dd817c0f0e451a3cfee43670b3f0c3fc3"
  scriptHash : String := "65c197d565e88a20885e535f93755682444d3c02fd44dd70883fe89e"
  datumHash : String := "db583ad85881a96c73fbb26ab9e24d1120bb38f45385664bb9c797a2ea8d9a2d"
  drepId : String := "drep1yg343cyuckglj48a6gpcey7fkfcy5x5f9g65wme3ne9q2mgaedmkm"
  proposalTxHash : String := "315682855f6c1e550b7495034604a85627c264243859d2279145683316f73e58"
  proposalTxHash2 : String := "9ba6a580bceb8f94e65a683e8291c89382835f46e3cf928eb521f5581ade4820"
  proposalCertIndex : Nat := 0
  metadataLabel: String := "1968"
  policyId: String := "b863bc7369f46136ac1048adb2fa7dae3af944c3bbb2be2f216a8d4f"
  epochForTest: Nat := 269
  slotForTest: Nat := 30895909

-- Test result type
inductive TestResult where
  | success (name : String) (message : String := "")
  | failure (name : String) (error : String)
  | skipped (name : String) (reason : String)

instance : ToString TestResult where
  toString
  | .success name msg => s!"✅ {name}" ++ (if msg.isEmpty then "" else s!" - {msg}")
  | .failure name err => s!"❌ {name} - {err}"
  | .skipped name reason => s!"⏭️  {name} - {reason}"

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
    ("accounts.registrations", runTestOptional "GET /accounts/{stake_address}/registrations"
      (Blockfrost.Typed.accounts.registrations config.stakeAddress)),
    ("accounts.withdrawals", runTestOptional "GET /accounts/{stake_address}/withdrawals"
      (Blockfrost.Typed.accounts.withdrawals config.stakeAddress)),
    ("accounts.mirs", runTestOptional "GET /accounts/{stake_address}/mirs"
      (Blockfrost.Typed.accounts.mirs config.stakeAddress)),
    ("accounts.addresses", runTestOptional "GET /accounts/{stake_address}/addresses"
      (Blockfrost.Typed.accounts.addresses config.stakeAddress)),
    ("accounts.addresses.assets", runTestOptional "GET /accounts/{stake_address}/addresses/assets"
      (Blockfrost.Typed.accounts.addresses.assets config.stakeAddress)),
    ("accounts.addresses.total", runTestOptional "GET /accounts/{stake_address}/addresses/total"
      (Blockfrost.Typed.accounts.addresses.total config.stakeAddress)),
    ("accounts.utxos", runTestOptional "GET /accounts/{stake_address}/utxos"
      (Blockfrost.Typed.accounts.utxos config.stakeAddress))
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
    runTestOptional "GET /addresses/{address}/utxos/{asset}"
      (Blockfrost.Typed.addresses.utxos.byAsset config.addressForTest config.assetForTest),
    runTestOptional "GET /addresses/{address}/txs"
      (Blockfrost.Typed.addresses.txs config.addressForTest),
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
      (Blockfrost.Typed.assets.addresses config.assetForTest),
    runTestOptional "GET /assets/policy/{policy_id}"
      (Blockfrost.Typed.assets.policy.byPolicy config.policyId)
  ]

  tests.mapM id

def testBlocks (config : TestConfig) : BF (List TestResult) := do
  IO.println "🧱 Testing Blocks endpoints..."
  let tests := [
    runTestOptional "GET /blocks/latest"
      (Blockfrost.Typed.blocks.latest),
    runTestOptional "GET /blocks/latest/txs"
      (Blockfrost.Typed.blocks.latest.txs),
    runTestOptional "GET /blocks/latest/txs/cbor"
      (Blockfrost.Typed.blocks.latest.txs.cbor),
    runTestOptional "GET /blocks/{hash_or_number}"
      (Blockfrost.Typed.blocks.byHash "500"),
    runTestOptional "GET /blocks/{hash_or_number}/next"
      (Blockfrost.Typed.blocks.next "500"),
    runTestOptional "GET /blocks/{hash_or_number}/previous"
      (Blockfrost.Typed.blocks.previous "500"),
    runTestOptional "GET /blocks/slot/{slot_number}"
      (Blockfrost.Typed.blocks.slot.bySlot config.slotForTest),
    runTestOptional "GET /blocks/epoch/{epoch_number}/slot/{slot_number}"
      (Blockfrost.Typed.blocks.epoch.byEpochAndSlot 576 6810),
    runTestOptional "GET /blocks/{hash_or_number}/txs"
      (Blockfrost.Typed.blocks.txs "500"),
    runTestOptional "GET /blocks/{hash_or_number}/txs/cbor"
      (Blockfrost.Typed.blocks.txs.cbor "500"),
    runTestOptional "GET /blocks/{hash_or_number}/addresses"
      (Blockfrost.Typed.blocks.addresses "500")
  ]

  tests.mapM id

def testEpochs (config : TestConfig): BF (List TestResult) := do
  IO.println "📅 Testing Epochs endpoints..."
  let tests := [
    runTestOptional "GET /epochs/latest"
      (Blockfrost.Typed.epochs.latest),
    runTestOptional "GET /epochs/latest/parameters"
      (Blockfrost.Typed.epochs.latest.parameters),
    runTestOptional "GET /epochs/{epoch}"
      (Blockfrost.Typed.epochs.byEpoch config.epochForTest),
    runTestOptional "GET /epochs/{epoch}/next"
      (Blockfrost.Typed.epochs.next config.epochForTest),
    runTestOptional "GET /epochs/{epoch}/previous"
      (Blockfrost.Typed.epochs.previous config.epochForTest),
    runTestOptional "GET /epochs/{epoch}/stakes"
      (Blockfrost.Typed.epochs.stakes config.epochForTest),
    runTestOptional "GET /epochs/{epoch}/stakes/{pool_id}"
      (Blockfrost.Typed.epochs.stakes.byPool config.epochForTest config.poolId),
    runTestOptional "GET /epochs/{epoch}/blocks"
      (Blockfrost.Typed.epochs.blocks config.epochForTest),
    runTestOptional "GET /epochs/{epoch}/blocks/{pool_id}"
      (Blockfrost.Typed.epochs.blocks.byPool config.epochForTest config.poolId),
    runTestOptional "GET /epochs/{epoch}/parameters"
      (Blockfrost.Typed.epochs.parameters config.epochForTest)
  ]

  tests.mapM id

def testGovernance (config : TestConfig) : BF (List TestResult) := do
  IO.println "🗳️  Testing Governance endpoints..."
  let tests := [
    runTestOptional "GET /governance/dreps"
      (Blockfrost.Typed.governance.dreps),
    runTestOptional "GET /governance/dreps/{drep_id}"
      (Blockfrost.Typed.governance.dreps.byDrep config.drepId),
    runTestOptional "GET /governance/dreps/{drep_id}/delegators"
      (Blockfrost.Typed.governance.dreps.delegators config.drepId),
    runTestOptional "GET /governance/dreps/{drep_id}/metadata"
      (Blockfrost.Typed.governance.dreps.metadata config.drepId),
    runTestOptional "GET /governance/dreps/{drep_id}/updates"
      (Blockfrost.Typed.governance.dreps.updates config.drepId),
    runTestOptional "GET /governance/dreps/{drep_id}/votes"
      (Blockfrost.Typed.governance.dreps.votes config.drepId),
    runTestOptional "GET /governance/proposals"
      (Blockfrost.Typed.governance.proposals.root),
    runTestOptional "GET /governance/proposals/{tx_hash}/{cert_index}"
      (Blockfrost.Typed.governance.proposals.byTxAndCert config.proposalTxHash2 config.proposalCertIndex),
    runTestOptional "GET /governance/proposals/{tx_hash}/{cert_index}/parameters"
      (Blockfrost.Typed.governance.proposals.parameters config.proposalTxHash2 config.proposalCertIndex),
    runTestOptional "GET /governance/proposals/{tx_hash}/{cert_index}/withdrawals"
      (Blockfrost.Typed.governance.proposals.withdrawals config.proposalTxHash config.proposalCertIndex),
    runTestOptional "GET /governance/proposals/{tx_hash}/{cert_index}/votes"
      (Blockfrost.Typed.governance.proposals.votes config.proposalTxHash config.proposalCertIndex),
    runTestOptional "GET /governance/proposals/{tx_hash}/{cert_index}/metadata"
      (Blockfrost.Typed.governance.proposals.metadata config.proposalTxHash2 config.proposalCertIndex)
  ]

  tests.mapM id

def testLedger : BF (List TestResult) := do
  IO.println "📜 Testing Ledger endpoints..."
  let tests := [
    runTestOptional "GET /genesis"
      (Blockfrost.Typed.genesis)
  ]
  tests.mapM id

def testMetadata (config : TestConfig) : BF (List TestResult) := do
  IO.println "📄 Testing Metadata endpoints..."
  let tests := [
    runTestOptional "GET /metadata/txs/labels"
      (Blockfrost.Typed.metadata.txs.labels),
    runTestOptional "GET /metadata/txs/labels/{label}"
      (Blockfrost.Typed.metadata.txs.labels.byLabel config.metadataLabel),
    runTestOptional "GET /metadata/txs/labels/{label}/cbor"
      (Blockfrost.Typed.metadata.txs.labels.cbor config.metadataLabel)
  ]

  tests.mapM id

def testMetrics : BF (List TestResult) := do
  IO.println "📈 Testing Metrics endpoints..."
  let tests := [
    runTestOptional "GET /metrics"
      (Blockfrost.Typed.metrics),
    runTestOptional "GET /metrics/endpoints"
      (Blockfrost.Typed.metrics.endpoints)
  ]

  tests.mapM id

def testRoot : BF (List TestResult) := do
  IO.println "🌲 Testing Root endpoint..."
  let tests := [
    runTestOptional "GET /"
      (Blockfrost.Typed.root)
  ]

  tests.mapM id

def testScripts (config : TestConfig) : BF (List TestResult) := do
  IO.println "📜 Testing Scripts endpoints..."
  let tests := [
    runTestOptional "GET /scripts"
      (Blockfrost.Typed.scripts),
    runTestOptional "GET /scripts/{hash}"
      (Blockfrost.Typed.scripts.byHash config.scriptHash),
    runTestOptional "GET /scripts/{hash}/json"
      (Blockfrost.Typed.scripts.json config.scriptHash),
    runTestOptional "GET /scripts/{hash}/cbor"
      (Blockfrost.Typed.scripts.cbor config.scriptHash),
    runTestOptional "GET /scripts/{hash}/redeemers"
      (Blockfrost.Typed.scripts.redeemers config.scriptHash),
    runTestOptional "GET /scripts/datum/{datum_hash}"
      (Blockfrost.Typed.scripts.datum.byHash config.datumHash),
    runTestOptional "GET /scripts/datum/{datum_hash}/cbor"
      (Blockfrost.Typed.scripts.datum.cbor config.datumHash)
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
    runTestOptional "GET /pools/extended"
      (Blockfrost.Typed.pools.extended),
    runTestOptional "GET /pools/retired"
      (Blockfrost.Typed.pools.retired),
    runTestOptional "GET /pools/retiring"
      (Blockfrost.Typed.pools.retiring),
    runTestOptional "GET /pools/{pool_id}/history"
      (Blockfrost.Typed.pools.history config.poolId),
    runTestOptional "GET /pools/{pool_id}/metadata"
      (Blockfrost.Typed.pools.metadata config.poolId),
    runTestOptional "GET /pools/{pool_id}/relays"
      (Blockfrost.Typed.pools.relays config.poolId),
    runTestOptional "GET /pools/{pool_id}/delegators"
      (Blockfrost.Typed.pools.delegators config.poolId),
    runTestOptional "GET /pools/{pool_id}/blocks"
      (Blockfrost.Typed.pools.blocks config.poolId),
    runTestOptional "GET /pools/{pool_id}/updates"
      (Blockfrost.Typed.pools.updates config.poolId),
    runTestOptional "GET /pools/{pool_id}/votes"
      (Blockfrost.Typed.pools.votes config.poolId)
  ]

  tests.mapM id

def testTransactions (config : TestConfig) : BF (List TestResult) := do
  IO.println "📝 Testing Transactions endpoints..."
  let tests := [
    runTestOptional "GET /txs/{hash}"
      (Blockfrost.Typed.txs.byHash config.txHash),
    runTestOptional "GET /txs/{hash}/utxos"
      (Blockfrost.Typed.txs.utxos config.txHash),
    runTestOptional "GET /txs/{hash}/utxos"
      (Blockfrost.Typed.txs.utxos config.txHash),
    runTestOptional "GET /txs/{hash}/stakes"
      (Blockfrost.Typed.txs.stakes config.txHash),
    runTestOptional "GET /txs/{hash}/delegations"
      (Blockfrost.Typed.txs.delegations config.txHash),
    runTestOptional "GET /txs/{hash}/withdrawals"
      (Blockfrost.Typed.txs.withdrawals config.txHash),
    runTestOptional "GET /txs/{hash}/mirs"
      (Blockfrost.Typed.txs.mirs config.txHash),
    runTestOptional "GET /txs/{hash}/pool_updates"
      (Blockfrost.Typed.txs.poolUpdates config.txHash),
    runTestOptional "GET /txs/{hash}/pool_retires"
      (Blockfrost.Typed.txs.poolRetires config.txHash),
    runTestOptional "GET /txs/{hash}/metadata"
      (Blockfrost.Typed.txs.metadata config.txHash),
    runTestOptional "GET /txs/{hash}/metadata/cbor"
      (Blockfrost.Typed.txs.metadata.cbor config.txHashWithMetadata),
    runTestOptional "GET /txs/{hash}/redeemers"
      (Blockfrost.Typed.txs.redeemers config.txHash),
    runTestOptional "GET /txs/{hash}/required_signers"
      (Blockfrost.Typed.txs.requiredSigners config.txHash),
    runTestOptional "GET /txs/{hash}/cbor"
      (Blockfrost.Typed.txs.cbor config.txHash)
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
    testEpochs config,
    testGovernance config,
    testLedger,
    testMetadata config,
    testMetrics,
    testRoot,
    testScripts config,
    testMempool,
    testPools config,
    testTransactions config
  ].foldlM (fun acc test => do
    let results ← test
    return acc ++ results
  ) []

  return allResults

-- Specific test suites
def runAccountsTests : BF Unit := do
  let config : TestConfig := {}
  let results ← testAccounts config
  for result in results do
    IO.println result

def runAddressesTests : BF Unit := do
  let config : TestConfig := {}
  let results ← testAddresses config
  for result in results do
    IO.println result

def runAssetsTests : BF Unit := do
  let config : TestConfig := {}
  let results ← testAssets config
  for result in results do
    IO.println result

def runBlocksTests : BF Unit := do
  let config : TestConfig := {}
  let results ← testBlocks config
  for result in results do
    IO.println result

def runEpochsTests : BF Unit := do
  let config : TestConfig := {}
  let results ← testEpochs config
  for result in results do
    IO.println result

def runGovernanceTests : BF Unit := do
  let config : TestConfig := {}
  let results ← testGovernance config
  for result in results do
    IO.println result

def runHealthTests : BF Unit := do
  let results ← testHealth
  for result in results do
    IO.println result

def runLedgerTests : BF Unit := do
  let results ← testLedger
  for result in results do
    IO.println result

def runMempoolTests : BF Unit := do
  let results ← testMempool
  for result in results do
    IO.println result

def runMetadataTests : BF Unit := do
  let config : TestConfig := {}
  let results ← testMetadata config
  for result in results do
    IO.println result

def runMetricsTests : BF Unit := do
  let results ← testMetrics
  for result in results do
    IO.println result

def runNetworkTests : BF Unit := do
  let results ← testNetwork
  for result in results do
    IO.println result

def runPoolTests : BF Unit := do
  let config : TestConfig := {}
  let results ← testPools config
  for result in results do
    IO.println result

def runRootTests : BF Unit := do
  let results ← testRoot
  for result in results do
    IO.println result

def runScriptsTests : BF Unit := do
  let config : TestConfig := {}
  let results ← testScripts config
  for result in results do
    IO.println result

def runTransactionsTests : BF Unit := do
  let config : TestConfig := {}
  let results ← testTransactions config
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
