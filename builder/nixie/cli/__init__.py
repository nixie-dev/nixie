import functools
import click
import os
import logging

from click_option_group import OptionGroup
from rich.console       import Console
from rich.logging       import RichHandler

from .commands import init, add_tool, for_cmd, update

'''This module specifically defines all command line options for Nixie and
their documentation.
Respective subcommands are defined in submodules.
'''

builder_group = OptionGroup("Common build options (init, update, for)")

def _use_builder_group(fn):
    @builder_group.option('-I', '--with-channel', multiple=True, default=[],
                          help='Include a snapshot of Nix channel in the script.')
    @builder_group.option('--with-binaries', default=False, is_flag=True,
                          help='Embed prebuilt binaries for Linux and macOS in the script.')
    @builder_group.option('--with-sources', default=False, is_flag=True,
                          help='Embed source code required to build Nix in the script.')
    @builder_group.option('--extra-substituters', default='',
                          help='Like the Nix option of the same name, a space-separated string listing the Nix cache substituters to use by default. --extra-trusted-public-keys may need to be specified as well.')
    @builder_group.option('--extra-trusted-public-keys', default='',
                          help='Like the Nix option of the same name, a space-separated string listing the public keys for the extra Nix cache substituters.')
    @builder_group.option('--source-cache', default='nix-wrap.cachix.org', show_default=True,
                          help='The server from which the Nix script will download its resources. See Cachix API documentation for more information.')
    @builder_group.option('--sources-derivation', default='',
                          help='The hash or path to the Nix derivation containing .tar.gz archives for the Nix source code. See documentation for more info.')
    @builder_group.option('--binaries-derivation', default='',
                          help='The hash or path to the Nix derivation containing prebuilt static Nix binaries. See documentation for more info.')
    @functools.wraps(fn)
    def wrapper(*args, **kwargs):
        return fn(*args, **kwargs)
    return wrapper


@click.group(invoke_without_command=True,
             help='Automatically set up Nixie in the current repository')
@_use_builder_group
@click.option('-C', default='', type=click.types.Path(),
              help='Run in another directory instead of the current.')
@click.version_option()
@click.pass_context
def main(ctx: click.Context, **kwargs):
    '''This function serves two roles:
    It sets up prerequisites common to every command, such as the working directory
    and rich logger, and it handles calling the default action if no command is
    given.
    '''
    logging.basicConfig(
            level = os.getenv('NIXIE_LOG_LEVEL', 'INFO'),
            format = '%(message)s',
            handlers = [RichHandler(rich_tracebacks = True,
                                    tracebacks_suppress = [click],
                                    log_time_format = "")
                        ])
    if kwargs['c'] != '':
        os.chdir(kwargs['c'])
    if ctx.invoked_subcommand is None:
        init._cmd(Console(), nocommand=True, **kwargs)


@main.command("init", help='Install Nixie in the current repository')
@_use_builder_group
@click.option('-o', '--output-name', default='',
              help='Name of the resulting script. Special names such as \'nix-shell\' allow the script to run as that utility.')
@click.option('--auto', is_flag=True, default=False,
              help='Automatically detect which template to use according to other files.')
@click.option('--no-gitignore', is_flag=True, default=False,
              help='Do not add entries to .gitignore for the .nixie work directory.')
@click.option('--no-gitattributes', is_flag=True, default=False,
              help='Do not add Linguist info to .gitattributes for the generated script.')
def _init(**kwargs):
    init._cmd(Console(), **kwargs)


@main.command("update", help="Update or reconfigure the repository's Nix script")
@_use_builder_group
def _update(**kwargs):
    update._cmd(Console(), **kwargs)

@main.command("for", help="Install Nixie according to a template")
@click.argument('template', nargs=1)
@_use_builder_group
@click.option('-p', '--extra-package', multiple=True, default=[],
              help='Like the nix-shell -p option, a package or list of packages to be made available in your dev environment.')
@click.option('--no-git-init', is_flag=True, default=False,
              help='Fail if the current directory is not a Git repository.')
def _for(**kwargs):
    for_cmd._cmd(Console(), **kwargs)


@main.command("add-tool", help='Searches for command in Nixpkgs, then adds it to the repository')
@click.argument('command', nargs=-1, required=True)
def _add_tool(**kwargs):
    add_tool._cmd(Console(), **kwargs)
