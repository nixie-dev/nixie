from behave import given, when, then
from types import SimpleNamespace

@given("a Git repository")
def init_git(context):
    context.nixos.succeed("git init")

@given("a Nix wrapper generated with offline {offline}")
@when("the Nix wrapper is generated with offline {offline}")
def gen_offline(context, offline):
    cmdline = f"nixie init --sources-derivation {context.nixos.sources} --binaries-derivation {context.nixos.static_bins}"
    if "binaries" in offline:
        cmdline += " --with-binaries"
    if "sources" in offline:
        cmdline += " --with-sources"
    context.nixos.succeed(cmdline)

@when("a file is added to the rootless Nix store")
def add_store(context):
    context.nixos.succeed("echo -n 'Nixie test file' > my-file")
    context.storepath = context.nixos.succeed("./nix --nixie-ignore-system store add-file my-file")

@then("the file should be in the system Nix store")
def check_store(context):
    out = context.nixos.succeed(f"cat {context.storepath}")
    assert "Nixie test file" == out
