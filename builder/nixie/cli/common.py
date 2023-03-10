import git
import os
import re
import atexit
import tempfile
import shutil

from tarfile        import TarFile
from pathlib        import Path
from pzp            import Finder, GenericAction, InfoStyle
from logging        import error, warn, exception, debug
from urllib.error   import HTTPError
from copy           import deepcopy

from ..output       import script
from ..             import nix, nix_channels


defaultFeatures = script.NixieFeatures()
defaultFeatures.extra_features = []
defaultFeatures.extra_substituters = []
defaultFeatures.extra_trusted_public_keys = []

defaultFeatures.source_cache = "nix-wrap.cachix.org"

defaultFeatures.pinned_channels = []
defaultFeatures.include_sources = False
defaultFeatures.include_bins    = False


def get_cache():
    return Path(os.getenv('XDG_CACHE_HOME', '~/.cache')).expanduser()

def get_appcache():
    cach = get_cache().joinpath('nixie')
    cach.mkdir(exist_ok=True, parents=True)
    return cach

def mktmp() -> str:
    '''Create a temporary work directory and hook its deletion at exit.
    '''
    tdir = tempfile.mkdtemp(prefix='nixie-')
    cleanup = lambda: shutil.rmtree(tdir)
    atexit.register(cleanup)
    return tdir

def pick(prompt: str, opts, open_ended = False, **ws):
    '''Pick from a selection of items, displaying a leading prompt.
    If open_ended is set, the function is susceptible to return an item
    not in the original selection.
    Returns a boolean then a response.
    '''
    if len(opts) >= 8:
        ws.update(height=10)
    fnd = Finder(opts, prompt_str=prompt + ' ',
                 fullscreen=False,
                 layout='reverse',
                 **ws)
    try:
        fnd.show()
    except GenericAction as action:
        if action.selected_item is not None:
            return True, action.selected_item
        elif open_ended and action.line != '':
            return False, action.line
        else:
            return None

def ask(prompt: str, default = True, open_ended = False):
    '''Ask a yes/no question, displaying a leading prompt.
    If open_ended is set, the function is susceptible to return a string.
    '''
    qs = ["Yes", "No"] if default else ["No", "Yes"]
    w, result = pick(prompt, qs, open_ended, info_style = InfoStyle.HIDDEN)
    if open_ended and not w:
        return result
    else:
        return default if result == None else (result == "Yes")

def goto_git_root(fail=True):
    '''Figure out the location of the current Git repository root.
    '''
    try:
        gr = git.Repo(os.getcwd(), search_parent_directories=True)
        os.chdir(gr.git.rev_parse("--show-toplevel"))
    except git.exc.InvalidGitRepositoryError as e:
        if fail:
            error(f"{os.getcwd()}: Not a Git repository.")
            exit(1)
        else:
            warn(f"{os.getcwd()}: Not a Git repository.")
            raise e

def nix_chn_from_arg(arg: str) -> Path|TarFile:
    '''Parse the argument passed to --with-channel, and automatically invoke
    channel retrieval functions.
    If the argument is an URL, the returned object will be a TarFile.
    Otherwise, it will be a Path.
    '''
    if '=' in arg:
        name = arg.split('=')[0]
        path = arg.split('=')[1]
        if path[:5] == "http:" or path[:6] == "https:":
            try:
                return nix_channels.download_channel(path)
            except HTTPError as e:
                error(f"'{path}': {e.reason}")
                exit(1)
            except Exception:
                exception(f"'{path}': Unknown error.")
                exit(1)
        else:
            return Path(path)
    else:
        nc = nix_channels.find_channel(arg)
        if nc is not None:
            return nc
        else:
            error(f"Channel not found: '{arg}'. Try running 'nix-channel --update'.")
            exit(1)

def channels_from_args(args: dict, st = None) -> dict:
    '''Parses given command line arguments and extracts a fresh Nix channel
    dict from them, while prefetching Internet sources if applicable.
    '''
    newchns = dict()
    for chn in args['with_channel']:
        if '=' in chn:
            chn_name = chn[:chn.index('=')]
        else:
            chn_name = chn
        if st is not None:
            st.update(f"Retrieving Nix channel '{chn_name}'")
        newc = nix_chn_from_arg(chn)
        debug(f"Channel '{chn_name}' resolved to: {newc}")
        newchns.update({chn_name: newc})
    return newchns

def features_from_args(args: dict, old = defaultFeatures) -> script.NixieFeatures:
    '''Parses given command line arguments and constructs or updates a features
    object reflecting them.
    '''
    feat = deepcopy(old)
    if args['extra_experimental_features'] is not None:
        feat.extra_features = args['extra_experimental_features'].split(' ')
    feat.extra_substituters += args['extra_substituters'].split(' ')
    feat.extra_trusted_public_keys += args['extra_trusted_public_keys'].split(' ')
    if args['source_cache'] is not None:
        feat.source_cache = args['source_cache']
    if args['with_sources'] is not None:
        feat.include_sources = args['with_sources']
    if args['with_binaries'] is not None:
        feat.include_bins = args['with_binaries']
    return feat

def setup_git_root(nixname: str, skipgi, skipga):
    if not skipgi:
        with open('.gitignore', 'a+') as gi:
            gi.seek(0, 0)
            if not re.search('^/?\\.nixie', gi.read(), flags=re.MULTILINE):
                gi.write('\n.nixie\n')
            else:
                debug('.gitignore already has our rule')
    if not skipga:
        with open('.gitattributes', 'a+') as ga:
            ga.seek(0, 0)
            if not re.search(nixname, ga.read(), flags=re.MULTILINE):
                ga.write(f'\n{nixname}  linguist-generated=true\n')
            else:
                debug('.gitattributes already has our rule')
