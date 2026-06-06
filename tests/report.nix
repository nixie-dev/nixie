{ pkgs, lib, stdenv, allure, emptyDirectory, writeShellScript
  # A NixOS Behave test (with a .driver output) to run
  # or a Nix-Darwin Behave test
, test
, ... }:

stdenv.mkDerivation {
  name = "${test.name}-report";
  src = emptyDirectory;

  nativeBuildInputs = [
    allure
  ];

  buildPhase =
    if stdenv.hostPlatform.isLinux
    then
      ''
      ${lib.getExe test.driver} || true
      ''
    else
      ''
      ${writeShellScript "${test.name}-driver" test.buildCommand} || true
      '';

  installPhase = ''
    mkdir -p $out
    allure generate allure_output -o $out
  '';
}
