import git
from rich.console import Console
from logging      import debug, error

from ..           import common

def _cmd(console: Console, **args):
    error("Templates are not yet implemented.")
    exit(1)
    try:
        common.goto_git_root(fail=args['no_git_init'])
    except Exception as e:
        # Initialize Git repository if it does not exist
        if not args.get('no_git_init'):
            try:
                git.Repo.init(common.get_current_directory())
                debug("Git repository initialized.")
            except Exception as init_err:
                error(f"Failed to initialize Git repository: {init_err}")
                exit(1)
        else:
            error(f"Git repository not found and no initialization allowed: {e}")
            exit(1)
