from rich.console import Console
from logging      import debug, error
from os           import path

from ...output    import script
from ..           import common

def _cmd(console: Console, **args):
    ns: script.NixieScript
    common.goto_git_root()
    with console.status("Reading Nix script configuration...", spinner='dots12') as st:
        try:
            debug("Trying ./nix")
            ns = script.NixieScript('./nix')
        except:
            try:
                debug("Trying ./nix-shell")
                ns = script.NixieScript('./nix-shell')
            except:
                error("No nix script found in this repository. Run 'nixie init' to generate one.")
                exit(1)
    debug(ns.features.print_features())
    if ns.features.include_sources:
        debug("This script includes sources.")
    if ns.features.include_bins:
        debug("This script includes binaries.")
    debug("Included channels: %s" %list(ns.features.pinned_channels.keys()))
