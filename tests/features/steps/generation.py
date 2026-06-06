from behave import given, when, then
from types import SimpleNamespace

@when("the Nix wrapper is extracted")
def nixie_extract(context):
    context.nixos.succeed("./nix --nixie-extract")

@then("the Nix wrapper should contain these files")
def check_extracted(context):
    filelist = context.nixos.succeed("find nixie -maxdepth 2").split('\n')
    for row in context.table.rows:
        if f"nixie/{row.cells[0]}" not in filelist:
            raise AssertionError(f"Missing entry: {row.cells[0]}")
