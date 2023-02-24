{ pkgs ? import <nixpkgs> {} }:
let
  builder = pkgs.callPackage ./builder {};
in pkgs.mkShell {
  name = "nixie";

  nativeBuildInputs =
  [ builder
  ];
}
