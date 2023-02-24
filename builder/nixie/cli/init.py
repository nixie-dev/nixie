from rich.console import Console

def _cmd(console: Console, nocommand=False, **args):
    if nocommand:
        print("Called as root command")
    else:
        print("Called as init command")
