from rich.console import Console

from ..           import common

def _cmd(console: Console, **args):
    common.goto_git_root()
    print("nope")
