import git
import os

from pzp        import pzp
from logging    import error

def pick(prompt: str, opts):
    hg = { 'height': 10 } if len(opts) >= 8 else {}
    return pzp(opts, prompt_str=prompt + ' ',
               fullscreen=False,
               layout='reverse',
               **hg)

def ask(prompt: str, default_no = False):
    qs = ["No", "Yes"] if default_no else ["Yes", "No"]
    result = pick(prompt, qs)
    return (not default_no) if result == None else (result == "Yes")

def goto_git_root(cn):
    try:
        gr = git.Repo(os.getcwd(), search_parent_directories=True)
        os.chdir(gr.git.rev_parse("--show-toplevel"))
    except git.exc.InvalidGitRepositoryError:
        error(f"{os.getcwd()}: Not a Git repository.")
        exit(1)
