{ pkgs, nixie, sources, static-bins }:
pkgs.testers.nixosTest {
  name = "nixie-generates-offline-script";
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
    machine.wait_until_succeeds("./nix --nixie-extract")
    fs = machine.wait_until_succeeds("ls nixie")
    assert "nix.Linux.x86_64" in fs
  '';
}
