from rich.console import Console
from ...output    import script
from ..           import common

def _cmd(console: Console, **args):
    ns: script.NixieScript
    common.goto_git_root(console)
    with console.status("Reading Nix script configuration...", spinner='dots12') as st:
        ns = script.NixieScript('./nix')
    console.print(ns.features.print_features())
    if ns.features.include_sources:
        console.print("This script includes sources.")
    if ns.features.include_bins:
        console.print("This script includes binaries.")
    console.print("Included channels:", list(ns.features.pinned_channels.keys()))
