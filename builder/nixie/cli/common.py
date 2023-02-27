import git
import os

from pzp import pzp


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

def print_error(cn, *m, **mm):
    return cn.print(f'[red bold]Error[/red bold]:', *m, **mm)

def goto_git_root(cn):
    try:
        gr = git.Repo(os.getcwd(), search_parent_directories=True)
        os.chdir(gr.git.rev_parse("--show-toplevel"))
    except git.exc.InvalidGitRepositoryError:
        print_error(cn, os.getcwd() + ":", "Not a Git repository.")
        exit(1)
