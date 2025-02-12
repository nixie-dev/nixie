{ nixpkgs     ? <nixpkgs>
  # Nixpkgs import (from flake)

, nix-source   ? builtins.fetchGit "https://github.com/nixos/nix"
  # Nix packages flake

, fakedir     ? builtins.fetchGit "https://github.com/thesola10/fakedir"
  # libfakedir import (from flake)

, pkgs        ? import nixpkgs {}
  # Nixpkgs evaluated set

, libfakedir  ? pkgs.callPackage fakedir
  # libfakedir evaluated package

, ... }:

let
  builtSystems = [
    "x86_64-linux"
    "aarch64-linux"

    "x86_64-darwin"
    "aarch64-darwin"
  ];
  systemsPkgs =
    map (s:
      import nixpkgs { localSystem = s; }
    ) builtSystems;

  patchesForSystem = {
    "x86_64-darwin"   = [
      ./0000-darwin-disable-prelink.patch
      ./0001-darwin-add-cmake.patch
      ./0002-darwin-disable-embedded-shell.patch
    ];
    "aarch64-darwin"  = [
      ./0000-darwin-disable-prelink.patch
      ./0001-darwin-add-cmake.patch
      ./0002-darwin-disable-embedded-shell.patch
    ];

    "x86_64-linux"    = [];
    "aarch64-linux"   = [];
  };

  # The reason we do this is two-fold: first, the Nix build system isn't
  # a simple callPackage, so using the regular 'patches' attribute wouldn't
  # propagate to dependent modules.
  # Second, we also need to modify the Nix 
  nixPatched = s: pkgs.runCommand "nix-source-patched" {} ''
    cp -r ${nix-source} $out
    chmod +w -R $out
    cat ${builtins.foldl' (l: r: "${l} ${r}") "" patchesForSystem.${s}} \
      | ${pkgs.patch}/bin/patch -p1 -u -d $out
  '';
  nixPackage = r: (import (nixPatched r.system)).packages.${r.system}.nix-cli-static;
in
pkgs.stdenv.mkDerivation {
  name = "nix-static-binaries";
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
