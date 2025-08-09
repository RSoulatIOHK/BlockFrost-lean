import Lake
open Lake DSL System

package «curl-ffi-demo»

lean_lib «CurlFFI»

-- Build the C wrapper and link with Homebrew curl
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
    "-I", "/opt/homebrew/opt/curl/include"  -- <= your brew prefix
  ]
  let srcJob ← inputFile src false
  let oJob   ← buildO oFile srcJob cflags
  buildStaticLib (pkg.staticLibDir / name) #[oJob]

@[default_target]
lean_exe «demo» {
  root := `Main
  moreLinkArgs := #[
    "-L", "/opt/homebrew/opt/curl/lib",      -- <= your brew prefix
    "-lcurl",
    "-Wl,-rpath,/opt/homebrew/opt/curl/lib"  -- ensure it’s found at runtime
  ]
}
