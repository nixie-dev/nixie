{ pkgs, nixie, sources, static-bins }:
pkgs.testers.nixosTest {
  name = "nixie-runs-rootless";
  nodes = {
    machine = {
      environment.systemPackages = with pkgs; [
        nixie
        git
      ];
    };
  };

  testScript = ''
    start_all()

    machine.succeed("git init")
    machine.succeed("nixie init --sources-derivation ${sources} --binaries-derivation ${static-bins} --with-binaries")
    machine.succeed("./nix --nixie-ignore-system --version")
  '';
}
