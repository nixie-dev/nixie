import subprocess
import re
import os

from pathlib        import Path
from urllib.request import urlopen, Request

NIXIE_HOST = "nix-wrap.cachix.org"

EXPR_NIXIE_SOURCES = "github:nixie-dev/nixie#packages.x86_64-linux.sources"
EXPR_NIXIE_BINARIES = "github:nixie-dev/nixie#packages.x86_64-linux.static-bins"

NIX_COMMAND = [ 'nix', '--extra-experimental-features', 'nix-command flakes' ]


def hashify(path: str) -> str:
    '''Ensures that a given string is a bare Nix hash, for use with Cachix API.
    If the string is a path, extracts the hash from that path.
    '''
    if re.match('^[a-z0-9]+$', path):
        return path
    else:
        w = re.search('^/nix/store/([a-z0-9]+)-', path)
        return w.group(1)

def _filter_msgs(buf: str):
    pat1 = 'warning:'
    pat2 = 'searching up'
    return '\n'.join([m for m in buf.split('\n')
                      if  m[:len(pat1)] != pat1
                      and m[-len(pat2):] != pat2])


def flake_eval(expr: str) -> str:
    '''Evaluate a Nix flake expression and return a Nix store path

    This function calls the Nix binary.
    '''
    r = subprocess.run(NIX_COMMAND + ['eval', '--raw', expr], capture_output=True)
    if r.returncode != 0:
        raise RuntimeError(_filter_msgs(r.stderr.decode()))
    return r.stdout.decode('utf-8').strip()

def flake_build(expr: str) -> str:
    '''Evaluate and build a Nix flake expression and return the resulting
    store path

    This function calls the Nix binary.
    '''
    r = subprocess.run(NIX_COMMAND + ['build', '--print-out-paths', '--no-link', expr], capture_output=True)
    if r.returncode != 0:
        errs = '\n'.join([m.decode() for m in r.stderr.split(b'\n')
                                     if m[:8] != b'warning:'])
        raise RuntimeError(_filter_msgs(r.stderr.decode()))
    return r.stdout.decode('utf-8').strip()

def fetchCachix(host: str, path: str, dest: Path):
    '''Download a store path with a filelist using a Cachix-compatible API

    This function does not call the Nix binary.
    '''
    filelist: list[str]
    hs = {"User-Agent": "Mozilla/5.0"}
    dest_hash = Path(dest).joinpath(hashify(path))
    dest_hash.mkdir(parents=True, exist_ok=True)

    # don't even ask me why cachix blocks urllib specifically
    # user-agents are a mistake
    rq = Request(f'https://{host}/serve/{hashify(path)}/filelist', headers=hs)
    with urlopen(rq) as rq:
        filelist = [f.decode() for f in rq.read().split(b'\n') if len(f)]
    for file in filelist:
        with open(dest_hash.joinpath(file), 'wb') as fi:
            m = Request(f'https://{host}/serve/{hashify(path)}/{file}', headers=hs)
            with urlopen(m) as rq:
                fi.write(rq.read())
    dest_hash.joinpath('filelist').unlink(missing_ok=True)

def findIndex(path: str) -> list[str]:
    '''Scan nix-index for a derivation containing the given path.
    '''
    r = subprocess.run(['nix-locate', '-1', '--at-root', '-w', path], capture_output=True)
    if r.returncode != 0:
        raise RuntimeError(r.stderr.decode())
    results = [m.decode() for m in r.stdout.split(b'\n')
                          if m != b'' and m[0] != 40 and m[-1] != 41 ]
    if (len(results) == 0):
        raise FileNotFoundError(f'{path}: not in Nixpkgs index')
    else:
        return results
