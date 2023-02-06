{ pkgs ? import <nixpkgs> {} }:
let
  builder = pkgs.callPackage ./builder {};
in pkgs.mkShell {
  name = "nix-wrap";

  nativeBuildInputs =
  [ builder
  ];
}
