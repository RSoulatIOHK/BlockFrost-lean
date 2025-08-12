import Blockfrost.Env
import Blockfrost.Endpoints.Endpoints
import Blockfrost.Models.Models
import Blockfrost.Typed.Typed

open Blockfrost
open Blockfrost.BF
open Blockfrost.Models

def main : IO Unit := do
  let some pid ← IO.getEnv "BLOCKFROST_PROJECT_ID"
    | throw <| IO.userError "Set BLOCKFROST_PROJECT_ID"
  let env : Env := { base := "https://cardano-mainnet.blockfrost.io/api/v0", projectId := pid }

  BF.run env do
    if false then
      -- THIS IS USED TO SKIP THE API CALLS THAT WORK
      IO.println "Running the Blockfrost API Documentation examples"

      IO.println "GET /"
      let root ← Blockfrost.Typed.root
      IO.println root

      IO.println "GET /health"
      let health ← Blockfrost.Typed.health
      IO.println health

      IO.println "GET /health/clock"
      let clock ← Blockfrost.Typed.health.clock
      IO.println clock

      IO.println "GET /metrics"
      let metrics ← Blockfrost.Typed.metrics
      IO.println metrics

      IO.println "GET /metrics/endpoints"
      let endpoints ← Blockfrost.Typed.metrics.endpoints
      IO.println endpoints

      let stakeAddress := "stake1u9ylzsgxaa6xctf4juup682ar3juj85n8tx3hthnljg47zctvm3rc"

      IO.println "GET /accounts/{stake_address}"
      let account ← Blockfrost.Typed.accounts.byStake stakeAddress
      IO.println account
    else
      -- ACCOUNTS : TODO

      -- IO.println "GET /accounts/{stake_address}/rewards"
      -- let rewards ← Blockfrost.Typed.accounts.rewards stakeAddress
      -- IO.println rewards

      -- IO.println "GET /accounts/{stake_address}/history"
      -- let history ← Blockfrost.Typed.accounts.history stakeAddress
      -- IO.println history

      -- IO.println "GET /accounts/{stake_address}/delegations"
      -- let delegations ← Blockfrost.Typed.accounts.delegations stakeAddress
      -- IO.println delegations

      -- IO.println "GET /accounts/{stake_address}/registrations"
      -- let registrations ← Blockfrost.Typed.accounts.registrations stakeAddress
      -- IO.println registrations

      -- IO.println "GET /accounts/{stake_address}/withdrawals"
      -- let withdrawals ← Blockfrost.Typed.accounts.withdrawals stakeAddress
      -- IO.println withdrawals

      -- IO.println "GET /accounts/{stake_address}/mirs"
      -- let mirs ← Blockfrost.Typed.accounts.mirs stakeAddress
      -- IO.println mirs

      -- IO.println "GET /accounts/{stake_address}/addresses"
      -- let addresses ← Blockfrost.Typed.accounts.addresses stakeAddress
      -- IO.println addresses

      -- IO.println "GET /accounts/{stake_address}/assets"
      -- let assets ← Blockfrost.Typed.accounts.assets stakeAddress
      -- IO.println assets

      -- IO.println "GET /accounts/{stake_address}/addresses/total"
      -- let totalAddresses ← Blockfrost.Typed.accounts.totalAddresses stakeAddress
      -- IO.println totalAddresses

      -- IO.println "GET /accounts/{stake_address}/utxos
      -- let utxos ← Blockfrost.Typed.accounts.utxos stakeAddress
      -- IO.println utxos

      -- ADDRESSES
      let addressForTest := "addr1qxqs59lphg8g6qndelq8xwqn60ag3aeyfcp33c2kdp46a09re5df3pzwwmyq946axfcejy5n4x0y99wqpgtp2gd0k09qsgy6pz"
      let assetForTest := "b863bc7369f46136ac1048adb2fa7dae3af944c3bbb2be2f216a8d4f426572727953616765"

      IO.println "GET /addresses/{address}"
      let address ← Blockfrost.Typed.addresses.byAddress addressForTest
      IO.println address

      IO.println "GET /addresses/{address}/extended"
      let extendedInfoAddress ← Blockfrost.Typed.addresses.extended addressForTest
      IO.println extendedInfoAddress

      IO.println "GET /addresses/{address}/total"
      let totalAddress ← Blockfrost.Typed.addresses.total addressForTest
      IO.println totalAddress

      IO.println "GET /addresses/{address}/utxos"
      let utxos ← Blockfrost.Typed.addresses.utxos addressForTest
      IO.println utxos

      IO.println "GET /addresses/{address}/utxos/{asset}"
      let utxoAsset ← Blockfrost.Typed.addresses.utxos.byAsset addressForTest assetForTest
      IO.println utxoAsset

      -- DEPRECATED GET /addresses/{address}/txs

      IO.println "GET /addresses/{address}/transactions"
      let transactions ← Blockfrost.Typed.addresses.transactions addressForTest
      IO.println transactions

      -- ASSETS
      IO.println "GET /assets"
      let assets ← Blockfrost.Typed.assets
      IO.println assets

      IO.println "GET /assets/{asset}"
      let assetInfo ← Blockfrost.Typed.assets.byAsset assetForTest
      IO.println assetInfo

      -- IO.println "GET /assets/{asset}/history"
      -- let assetHistory ← Blockfrost.Typed.assets.history assetForTest
      -- IO.println assetHistory

      -- DEPRECATED GET /assets/{asset}/txs

      -- IO.println "GET /assets/{asset}/transactions"
      -- let assetTransactions ← Blockfrost.Typed.assets.transactions assetForTest
      -- IO.println assetTransactions

      -- IO.println "GET /assets/{asset}/addresses"
      -- let assetAddresses ← Blockfrost.Typed.assets.addresses assetForTest
      -- IO.println assetAddresses

      -- IO.println "GET /assets/{asset}/{policy_id}"
      -- let assetPolicyId ← Blockfrost.Typed.assets.policyId assetForTest
      -- IO.println assetPolicyId
