{ nixpkgs, nixie, sources, static-bins
, system ? builtins.currentSystem, nix-darwin ? {}, ... }@as:

let
  pkgs = import nixpkgs { inherit system; };

  makeDarwinTest = import ./makeDarwinTest.nix as;
  makeLinuxTest = f: pkgs.callPackage f as;

  makeTest = t:
    if pkgs.stdenv.isLinux       then makeLinuxTest ./linux/${t}.nix
    else if pkgs.stdenv.isDarwin then makeDarwinTest ./darwin/${t}.nix
    else throw "Unsupported platform: ${pkgs.stdenv.platform}";
in {

  # Tests available on both platforms
  building   = makeTest "building";
  generation = makeTest "generation";
  migration  = makeTest "migration";
  rootless   = makeTest "rootless";

} // (if pkgs.stdenv.isLinux then {

  # Linux-specific tests go here

} else if pkgs.stdenv.isDarwin then {

  # macOS-specific tests go here

} else {})
