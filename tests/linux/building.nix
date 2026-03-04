{ pkgs, nixie, sources, static-bins, ... }:
pkgs.testers.nixosTest {
  name = "nixie-builds-nix-from-source";
  nodes = {
    machine = {
      environment.systemPackages = with pkgs; [
        nixie
        git

        gcc
        pkg-config
        gnumake
        flex
        bison
        perl
      ];
    };
  };

  testScript = ''
    start_all()

    machine.succeed("git init")
    machine.succeed("nixie init --sources-derivation ${sources} --binaries-derivation ${static-bins} --with-sources")
    machine.succeed("./nix --nixie-no-precompiled --version")
  '';
}
