import tempfile

from rich.console   import Console
from logging        import debug, error, warn

from ...output      import script
from ..             import common

def _cmd(console: Console, nocommand=False, **args):
    common.goto_git_root()
    if nocommand or args['auto']:
        warn("Templates are not yet implemented.")
    console.print("(dummy) Running init")

    #TODO: add and use that when prefetching
    #tempfile.mkdtemp(prefix='nixie-')
