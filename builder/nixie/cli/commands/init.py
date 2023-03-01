import tempfile

from rich.console   import Console

from ...output      import script
from ..             import common

def _cmd(console: Console, nocommand=False, **args):
    common.goto_git_root()
    if nocommand or args['auto']:
        console.print("(dummy) Performing auto scan")
        common.ask("Die? ")
    console.print("(dummy) Running init")

    #TODO: add and use that when prefetching
    #tempfile.mkdtemp(prefix='nixie-')
