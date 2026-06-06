from behave import given, when, then
from types import SimpleNamespace

@when("the Nix wrapper is launched with system Nix")
def system_nix(context):
    context.nixos.succeed("./nix --version")

@then("the Nix wrapper launches Nix without root")
def check_nix(context):
    context.nixos.succeed("./nix --nixie-ignore-system --version")

@then("the Nix wrapper builds Nix from source")
def build_nix(context):
    context.nixos.succeed("./nix --nixie-no-precompiled --version")
