{ nixpkgs ? <nixpkgs>
, fakedir ? builtins.fetchGit "https://github.com/thesola10/fakedir"
, pkgs ? import nixpkgs {}
, libfakedir ? pkgs.callPackage fakedir
, ... }:

let
  builtSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
  systemsNixpkgs = map (s: import nixpkgs { system = s; }) builtSystems;
in pkgs.stdenv.mkDerivation {
  pname = "nix-static-binaries";
  version = "0.0.1";

  src = pkgs.emptyDirectory;

  installPhase = 
    let
      sys = r: r.stdenv.hostPlatform.uname.system;
      cpu = r: r.stdenv.hostPlatform.uname.processor;
    in builtins.foldl'
      (l: r: "${l}; cp ${r.nixStatic}/bin/nix $out/nix.${sys r}.${cpu r}")
      "mkdir -p $out" 
      systemsNixpkgs;
}
