import tempfile
import stat
import os

from rich.console   import Console
from logging        import debug, error, warn

from ...output      import script
from ...            import nix
from ..             import common,fetchers

def _cmd(console: Console, nocommand=False, **args):
    outn: str

    tdir = tempfile.mkdtemp(prefix='nixie-')

    if 'output_name' in args and args['output_name'] != '':
        outn = args['output_name']
    else:
        common.goto_git_root()
        outn = './nix'

    if nocommand or args['auto']:
        warn("Templates are not yet implemented.")

    chns = dict()
    srcs_eval: str
    bins_eval: str

    with console.status("Retrieving Nix channels...", spinner='earth') as st:
        chns = common.channels_from_args(args, st)
    with console.status("Fetching latest resources...", spinner="earth") as st:
        srcs_eval, bins_eval = fetchers.eval_latest_sources(args)

    feats = common.features_from_args(args)
    feats.sources_drv = srcs_eval
    feats.bins_drv = bins_eval
    feats.pinned_channels = chns

    with console.status("Downloading offline binaries...", spinner="earth") as st:
        fetchers.prefetch_resources(feats.source_cache, tdir, bins_eval, srcs_eval, args, st)

    scr = script.NixieScript(feats)

    with console.status("Building script...", spinner='dots12') as st:
        with open(outn, mode='wb') as fi:
            scr.build(fi, tdir)
    os.chmod(outn, os.stat(outn).st_mode | stat.S_IEXEC)
