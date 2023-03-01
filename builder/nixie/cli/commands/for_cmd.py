import git

from rich.console import Console

from ..           import common

def _cmd(console: Console, **args):
    console.print(args)
    try:
        common.goto_git_root(fail=args['no_git_init'])
    except Exception:
        # TODO: perform Git init
        pass
