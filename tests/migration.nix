{ pkgs, nixie, sources, static-bins }:
pkgs.testers.nixosTest {
  name = "nixie-migrates-rootless-paths";
  nodes = {
    machine = {
      environment.systemPackages = with pkgs; [
        nixie
        git
      ];

      virtualisation.writableStore = true;
    };
  };

  testScript = ''
    start_all()

    machine.succeed("git init")
    machine.wait_until_succeeds("nixie init --sources-derivation ${sources} --binaries-derivation ${static-bins} --with-binaries")
    machine.wait_until_succeeds("echo -n 'Nixie test file' > /my-file")

    f = machine.wait_until_succeeds("./nix --nixie-ignore-system store add-file /my-file")
    machine.fail(f"cat {f}")

    # Running without ignore-system should cause rootless-created paths to be
    # copied over to the system store.
    machine.wait_until_succeeds("./nix --version")
    out = machine.succeed(f"cat {f}")
    assert "Nixie test file" == out, f"expected 'Nixie test file', got '{out}'"
  '';
}
