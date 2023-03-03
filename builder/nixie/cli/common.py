import git
import os

from tarfile        import TarFile
from pathlib        import Path
from pzp            import Finder, GenericAction, InfoStyle
from logging        import error, warn, exception
from urllib.error   import URLError, HTTPError
from copy           import deepcopy

from ..output       import script
from ..             import nix_channels


defaultFeatures = script.NixieFeatures()
defaultFeatures.extra_features = []
defaultFeatures.extra_substituters = []
defaultFeatures.extra_trusted_public_keys = []

defaultFeatures.source_cache = "nix-wrap.cachix.org"

defaultFeatures.pinned_channels = []
defaultFeatures.include_sources = False
defaultFeatures.include_bins    = False

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

def features_from_args(args: dict, old: script.NixieFeatures = defaultFeatures) -> script.NixieFeatures:
    feat = deepcopy(old)
    if args['extra_experimental_features'] != '':
        feat.extra_features = args['extra_experimental_features'].split(' ')
    feat.extra_substituters += args['extra_substituters'].split(' ')
    feat.extra_trusted_public_keys += args['extra_trusted_public_keys'].split(' ')
    if args['source_cache'] != '':
        feat.source_cache = args['source_cache']
    if args['sources_derivation'] != '':
        feat.sources_drv = args['sources_derivation']
    if args['binaries_derivation'] != '':
        feat.bins_drv = args['binaries_derivation']
    if args['with_sources'] is not None:
        feat.include_sources = args['with_sources']
    if args['with_binaries'] is not None:
        feat.include_bins = args['with_binaries']
    return feat
