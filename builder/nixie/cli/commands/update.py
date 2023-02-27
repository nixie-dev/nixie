from rich.console import Console
from logging      import debug

from ...output    import script
from ..           import common

def _cmd(console: Console, **args):
    ns: script.NixieScript
    common.goto_git_root(console)
    with console.status("Reading Nix script configuration...", spinner='dots12') as st:
        ns = script.NixieScript('./nix')
    debug(ns.features.print_features())
    if ns.features.include_sources:
        debug("This script includes sources.")
    if ns.features.include_bins:
        debug("This script includes binaries.")
    debug("Included channels: %s" %list(ns.features.pinned_channels.keys()))
