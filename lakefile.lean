import Lake
open Lake DSL System

package «blockfrost-lean4»

lean_lib «CurlFFI»
lean_lib «Blockfrost»
lean_lib «Tests»
lean_lib «Examples»

-- Build the C wrapper and link with curl
extern_lib «http_client» pkg := do
  let name   := nameToStaticLib "http_client"
  let cDir   := pkg.dir / "c"
  let oDir   := pkg.buildDir / "c"
  let src    := cDir / "http_client.c"
  let oFile  := oDir / "http_client.o"
  IO.FS.createDirAll oDir

  let cflags := #[
    "-fPIC", "-O2",
    "-I", (← getLeanIncludeDir).toString,
    "-I", "/opt/homebrew/opt/curl/include" -- Need to check where it gets otherwise
  ]

  let srcJob ← inputFile src false
  let oJob   ← buildO oFile srcJob cflags
  buildStaticLib (pkg.staticLibDir / name) #[oJob]

@[default_target]
lean_exe «blockfrost-test» {
  root := `Main
  moreLinkArgs := #[
    "-L", "/opt/homebrew/opt/curl/lib",
    "-lcurl",
    "-Wl,-rpath,/opt/homebrew/opt/curl/lib"
  ]
}
