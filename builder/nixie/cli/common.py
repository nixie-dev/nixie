import git
import os

from pzp        import Finder, GenericAction, InfoStyle
from logging    import error, warn

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
                 #layout='reverse',  # disabled due to andreax9/pzp#4
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
