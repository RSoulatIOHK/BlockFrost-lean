-- Main.lean (Refactored)
import Tests.TestSuite

def main (args : List String) : IO Unit := do
  match args with
  | [] =>
    -- Run all tests by default
    runTests
  | ["--help"] | ["-h"] =>
    IO.println "Blockfrost API Test Suite"
    IO.println "Usage:"
    IO.println "  ./demo                    # Run all tests"
    IO.println "  ./demo --help            # Show this help"
    IO.println "  ./demo health            # Run health tests only"
    IO.println "  ./demo accounts          # Run account tests only"
    IO.println "  ./demo network           # Run network tests only"
    IO.println ""
    IO.println "Environment variables:"
    IO.println "  BLOCKFROST_PROJECT_ID    # Required: Your Blockfrost project ID"
  | ["health"] =>
    runSpecificTest Tests.runHealthTests
  | ["accounts"] =>
    runSpecificTest (Tests.runAccountTests {})
  | ["network"] =>
    runSpecificTest Tests.runNetworkTests
  | [suite] =>
    IO.println s!"Unknown test suite: {suite}"
    IO.println "Run './demo --help' for available options"
  | _ =>
    IO.println "Too many arguments. Run './demo --help' for usage."

where
  runSpecificTest (test : Blockfrost.BF Unit) : IO Unit := do
    let some pid ← IO.getEnv "BLOCKFROST_PROJECT_ID"
      | throw <| IO.userError "Set BLOCKFROST_PROJECT_ID environment variable"
    let env : Blockfrost.Env := {
      base := "https://cardano-mainnet.blockfrost.io/api/v0",
      projectId := pid
    }
    Blockfrost.BF.run env test
