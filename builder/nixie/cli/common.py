import git
import os

from pzp        import Finder, GenericAction
from logging    import error

def pick(prompt: str, opts, open_ended = False):
    '''Pick from a selection of items, displaying a leading prompt.
    If open_ended is set, the function is susceptible to return an item
    not in the original selection.
    '''
    hg = { 'height': 10 } if len(opts) >= 8 else {}
    fnd = Finder(opts, prompt_str=prompt + ' ',
                 fullscreen=False,
                 layout='reverse',
                 **hg)
    try:
        fnd.show()
    except GenericAction as action:
        if action.selected_item is not None:
            return action.selected_item
        elif open_ended and action.line != '':
            return action.line
        else:
            return None

def ask(prompt: str, default_no = False, open_ended = False):
    '''Ask a yes/no question, displaying a leading prompt.
    If open_ended is set, the function is susceptible to return a string.
    '''
    qs = ["No", "Yes"] if default_no else ["Yes", "No"]
    result = pick(prompt, qs, open_ended)
    if open_ended and type(result) is not bool:
        return result
    else:
        return (not default_no) if result == None else (result == "Yes")

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
            raise e
