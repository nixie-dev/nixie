{ pkgs ? import <nixpkgs> {} }:
let
  builder = pkgs.callPackage ./. {};
in pkgs.mkShell {
  name = "nixie";

  nativeBuildInputs =
  [ builder
  ];
}
