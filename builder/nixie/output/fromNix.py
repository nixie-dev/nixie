import sys

from pathlib        import Path

NIXIE_HOST = "nix-wrap.cachix.org"

EXPR_NIXIE_SOURCES = "github:nixie-dev/nixie#packages.x86_64-linux.sources"
EXPR_NIXIE_BINARIES = "github:nixie-dev/nixie#packages.x86_64-linux.static-bins"

def flake_eval(expr: str) -> str:
    '''Evaluate a Nix flake expression and return a Nix store path

    This function calls the Nix binary.
    '''
    pass

def flake_build(expr: str) -> str:
    '''Evaluate and build a Nix flake expression and return the resulting
    store path

    This function calls the Nix binary.
    '''
    pass

def fetchCachix(host: str, path: str, member: str, dest: Path):
    '''Download a store path member using a Cachix-compatible API

    This function does not call the Nix binary.
    '''
    pass

def fetchHydra(host: str, path: str):
    '''Download a store path using Nix's native NAR acquisition system

    This function calls the Nix binary.
    '''
    pass
