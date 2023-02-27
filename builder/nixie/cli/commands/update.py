from rich.console import Console
from ...output    import script

def _cmd(console: Console, **args):
    ns: script.NixieScript
    with console.status("Reading Nix script settings...", spinner='dots12') as st:
        ns = script.NixieScript('./nix')
    console.print(ns.features.print_features())
