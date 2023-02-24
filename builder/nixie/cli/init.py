from click import Context

def _cmd(ctx: Context, nocommand=False, **args):
    if nocommand:
        print("Called as root command")
    else:
        print("Called as init command")
