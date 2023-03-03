import git
import os

from tarfile        import TarFile
from pathlib        import Path
from pzp            import Finder, GenericAction, InfoStyle
from logging        import error, warn, exception
from urllib.error   import URLError, HTTPError
from ..             import nix_channels

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
