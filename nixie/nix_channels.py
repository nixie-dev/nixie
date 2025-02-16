import subprocess
import re
import os

from pathlib        import Path
from urllib         import request
from tarfile        import TarFile

def _get_nixpath_entry(name: str) -> Path:
    '''Find a mapping path (which contains '=') from the NIX_PATH that
    matches the given channel name.
    '''
    nixpath = os.getenv('NIX_PATH')
    _startswith = lambda m, n: m[:len(n)] == n
    if nixpath is not None:
        match = [m for m in nixpath.split(':') if _startswith(m, name + "=")]
        if len(match) > 0:
            return Path(match[0][len(name + "="):])
    return None

def _get_nixpath_dirs() -> list[Path]:
    '''Extract lookup paths (which do not contain '=') from the NIX_PATH
    variable into a list.
    '''
    nixpath = os.getenv('NIX_PATH')
    if nixpath is not None:
        return [Path(m) for m in nixpath.split(':') if '=' not in m]
    return None

def find_channel(name: str) -> Path:
    '''Finds a Nix channel by name on the user's system.
    '''
    # Try NIX_PATH mapping
    np = _get_nixpath_entry(name)
    if np is not None:
        return np

    # Try NIX_PATH lookup
    for dr in _get_nixpath_dirs():
        if dr.joinpath(name).exists():
            return dr.joinpath(name)

    # Try .nix-defexpr lookup
    defexpr = Path.home().joinpath('.nix-defexpr')
    if defexpr.joinpath('channels').joinpath(name).exists():
        return defexpr.joinpath('channels').joinpath(name)
    if defexpr.joinpath('channels_root').joinpath(name).exists():
        return defexpr.joinpath('channels_root').joinpath(name)

    # No match.
    return None

def download_channel(url: str) -> TarFile:
    '''Downloads a Nix channel from a given URL into a streamed TarFile.
    '''
    session = None
    m = re.search(".*\\.tar\\.([gx]z|bz2|zstd)$", url)
    if m is not None:
        session = request.urlopen(url)
        return TarFile.open(fileobj=session, mode='r|'+m[1])
    else:
        session = request.urlopen(url + "/nixexprs.tar.xz")
        return TarFile.open(fileobj=session, mode='r:xz')

def _nixpkgs_getver(svnrev: str):
    '''Extracts the revision number from the 'svn-revision' format
    and joins a boolean that indicates if the revision file is from
    the NixOS branch.
    '''
    is_nixos = False
    if svnrev[0] == '.':
        is_nixos = True
        svnrev = svnrev[1:]
    return int(svnrev[:svnrev.find('.')]), is_nixos

def check_nixpkgs_newer(ours: str, theirs: str) -> bool:
    '''For Nixpkgs only, compares 'svn-revision' values to determine if
    our local copy is newer and worth updating.
    This check will deliberately fail if one of the channels is NixOS
    but the other is not.
    '''
    ourver, ournixos = _nixpkgs_getver(ours)
    theirver, theirnixos = _nixpkgs_getver(theirs)
    return ourver > theirver if ournixos == theirnixos else False
