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
    IO.println "  ./demo --help             # Show this help"
    IO.println "  ./demo accounts           # Run account-related tests"
    IO.println "  ./demo addresses          # Run address-related tests"
    IO.println "  ./demo assets             # Run asset-related tests"
    IO.println "  ./demo blocks             # Run block-related tests"
    IO.println "  ./demo epochs             # Run epoch-related tests"
    IO.println "  ./demo governance         # Run governance-related tests"
    IO.println "  ./demo health             # Run health tests only"
    IO.println "  ./demo ledgers            # Run ledger tests only"
    IO.println "  ./demo mempool            # Run mempool tests only"
    IO.println "  ./demo metadata           # Run metadata tests only"
    IO.println "  ./demo metrics            # Run metrics tests only"
    IO.println "  ./demo network            # Run network tests only"
    IO.println "  ./demo pools              # Run pool tests only"
    IO.println "  ./demo root               # Run root tests only"
    IO.println "  ./demo scripts            # Run script tests only"
    IO.println "  ./demo transactions       # Run transaction tests only"
    IO.println ""
    IO.println "Environment variables:"
    IO.println "  BLOCKFROST_PROJECT_ID    # Required: Your Blockfrost project ID"
  | [suite] =>
    IO.println s!"Unknown test suite: {suite}"
    IO.println "Run './demo --help' for available options"
  | _ =>
    IO.println "Too many arguments. Run './demo --help' for usage."
