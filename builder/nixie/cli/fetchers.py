import os

from logging        import debug, warn, error
from urllib.request import urlopen
from pathlib        import Path
from .              import common
from ..             import nix, nix_channels
from ..output       import script

def download_nix_index():
    nid = common.get_cache().joinpath('nix-index')
    nid.mkdir(exist_ok=True, parents=True)

    fname = f"index-{os.uname().machine}-{os.uname().sysname.lower()}"
    url = "https://github.com/Mic92/nix-index-database/releases/latest/download/" + fname
    with open(nid.joinpath('files'), 'wb') as nif:
        with urlopen(url) as idx:
            nif.write(idx.read())

def _rsrc_fallback(what, e):
    try:
        with open(common.get_appcache().joinpath(what), 'r') as fi:
            warn("Failed to retrieve latest resources, using last known.")
            return fi.read()
    except:
        error("Failed to retrieve latest resources.")
        error(e.args[0])
        exit(1)

def eval_latest_sources(args: dict, st = None):
    '''Evaluates and/or retrieves the latest derivations for sources and
    binaries, and performs prefetch if appropriate.
    '''
    if args['sources_derivation'] == '':
        try:
            srcs_eval = nix.flake_eval(nix.EXPR_NIXIE_SOURCES)
            with open(common.get_appcache().joinpath('srcs'), 'w') as fi:
                fi.write(srcs_eval)
        except RuntimeError as e:
            srcs_eval = _rsrc_fallback('srcs', e)
    else:
        srcs_eval = args['sources_derivation']
    if args['binaries_derivation'] == '':
        try:
            bins_eval = nix.flake_eval(nix.EXPR_NIXIE_BINARIES)
            with open(common.get_appcache().joinpath('bins'), 'w') as fi:
                fi.write(bins_eval)
        except RuntimeError as e:
            bins_eval = _rsrc_fallback('bins', e)
    else:
        bins_eval = args['binaries_derivation']
    debug(f"Sources derivation: {srcs_eval}")
    debug(f"Binaries derivation: {bins_eval}")
    return srcs_eval, bins_eval

def _tmplink(tdir: Path, drv: str):
    locdrv = list(Path('/nix/store/').glob(f'{drv}*'))
    if len(locdrv) == 0:
        error('Derivation could not be found locally. Check your Internet connection and supplied derivation hash then try again.')
    else:
        tdir.joinpath('{drv}').symlink_to(locdrv[0])

def prefetch_resources(tdir: Path,
                       feats: script.NixieFeatures,
                       st = None):
    if feats.include_bins:
        st.update("Downloading offline binaries...")
        try:
            nix.fetchCachix(feats.source_cache, feats.bins_drv, tdir)
        except:
            warn("Binaries derivation could not be downloaded.")
            _tmplink(tdir, feats.bins_drv)
    if feats.include_sources:
        st.update("Downloading offline sources...")
        try:
            nix.fetchCachix(feats.source_cache, feats.sources_drv, tdir)
        except:
            warn("Sources derivation could not be downloaded.")
            _tmplink(tdir, feats.sources_drv)
