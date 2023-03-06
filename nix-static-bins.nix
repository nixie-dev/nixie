{ nixpkgs     ? <nixpkgs>
  # Nixpkgs import (from flake)

, fakedir     ? builtins.fetchGit "https://github.com/thesola10/fakedir"
  # libfakedir import (from flake)

, pkgs        ? import nixpkgs {}
  # Nixpkgs evaluated set

, libfakedir  ? pkgs.callPackage fakedir
  # libfakedir evaluated package

, nixStatics  ? {}
  # Per-architecture set of static Nix binaries (non-exhaustive)

, ... }:

let
  builtSystems = [
    "x86_64-linux"
    "aarch64-linux"

    # Support on hold pending bintools fixes
    #"x86_64-darwin"
    #"aarch64-darwin"
  ];
  systemsPkgs =
    map (s:
      let parsedSystem = pkgs.lib.systems.parse.mkSystemFromString s;
      in import nixpkgs ({ localSystem = s; }
      // (if parsedSystem.kernel.name == "darwin"
          then
          { overlays =
            [ (import ./nixpkgs-darwin-static.nix) ];
            crossSystem = {
              isStatic = true;
              system = s;
            };
          }
          else {}))
    ) builtSystems;

  nixPackage = r: if builtins.hasAttr "${r.system}" nixStatics
                  then nixStatics."${r.system}"
                  else r.nixStatic;
in
pkgs.stdenv.mkDerivation {
  pname = "nix-static-binaries";
  version = "0.0.1";
  src = pkgs.emptyDirectory;

  installPhase =
    let
      sys = r: r.stdenv.hostPlatform.uname.system;
      cpu = r: r.stdenv.hostPlatform.uname.processor;
    in (builtins.foldl'
      (l: r: "${l}; cp ${nixPackage r}/bin/nix $out/nix.${sys r}.${cpu r}")
      "mkdir -p $out"
      systemsPkgs)
    + '';
      cp ${libfakedir}/lib/libfakedir.dylib $out/libfakedir.dylib
      ls $out > $out/filelist
    '';
} // builtins.foldl'
  (l: r: l // { "${r.system}-nix-static" = nixPackage r; })
  { fakedir = libfakedir; } systemsPkgs
