import git

from rich.console import Console
from logging      import debug, error

from ..           import common

def _cmd(console: Console, **args):
    error("Templates are not yet implemented.")
    exit(1)
    try:
        common.goto_git_root(fail=args['no_git_init'])
    except Exception:
        # TODO: perform Git init
        pass
