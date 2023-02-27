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


