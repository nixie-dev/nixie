{ config, pkgs, nixie, sources, static-bins ... }:

{
  environment.systemPackages = with pkgs; [
    nixie
    git
  ];

  test = ''
    git init
    nixie init --sources-derivation ${sources} --binaries-derivation ${static-bins} --with-binaries
    ./nix --nixie-extract
    ls nixie | grep nix.Darwin.x86_64
  '';
}
