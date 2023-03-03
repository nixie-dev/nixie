import tarfile as tf
import re

from pathlib import Path
from io      import BytesIO
from os      import path
from logging import debug
from copy    import deepcopy

from .script import NixieFeatures
from ..      import nix

class ResourceTarball:
    '''An object representing the tarball appended to a Nixie-generated script.
    '''
    features: NixieFeatures
    original: tf.TarFile

    def __init__(self, origin: NixieFeatures | BytesIO):
        '''Construct the object, either from a generated NixieFeatures, or
        from an existing tarball buffer.
        Existing tarball construction may take a while.
        '''
        if type(origin) is NixieFeatures:
            self.features = origin
            self.original = None
        else:
            self.original = tf.open(fileobj=origin, mode='r:gz')
            self.features = NixieFeatures(self.original.extractfile('features'))
            mms = self.original.getmembers()
            chns = [ fi.name for fi in mms if re.match('^channels/[a-zA-Z0-9_-]+$', fi.name) ]
            self.features.pinned_channels = { k[9:]: None for k in chns }
            self.features.include_sources = 'sources' in [ m.name for m in mms ]
            self.features.include_bins = 'nix-static.Linux.x86_64' in [ m.name for m in mms ]

    def __del__(self):
        '''Destructor to close the original archive if it was used in the
        creation of this object.
        '''
        if self.original is not None:
            self.original.close()

    def _push_channel(self, n: tf.TarFile, name, tgt):
        '''Push a Nix channel into the archive, either from the specified path,
        or from the original archive in memory (if applicable)
        '''
        if type(tgt) is tf.TarFile:
            debug(f"Adding channel '{name}' from tarball")
            self.transplant(n, tgt, f'channels/{name}', strip_root=True)
        elif tgt is not None:
            debug(f"Adding channel '{name}' from {tgt}")
            n.add(path.realpath(tgt), f'channels/{name}')
        else:
            debug(f"Transferring channel '{name}' to new archive")
            mms = self.original.getmembers()
            chn = [ fi for fi in mms if re.match(f'^channels/{name}/.*', fi.name) ]
            for fil in chn:
                if fil.isfile():
                    n.addfile(fil, self.original.extractfile(fil))
                else:
                    n.addfile(fil)

    def transplant(self, n: tf.TarFile, src: tf.TarFile, prefix: str, strip_root=False):
        '''Write the entire contents of a given tarball into ours,
        usually for including source archives for offline use.
        Suitable for stream use.
        '''
        fs = src.next()
        while fs is not None:
            newfs = deepcopy(fs)
            if strip_root:
                newfs.name = re.sub("^[a-zA-Z0-9.-]*/", "%s/" %prefix, fs.name)
            else:
                newfs.name = prefix + '/' + fs.name
            if fs.isfile():
                n.addfile(newfs, src.extractfile(fs))
            else:
                n.addfile(newfs)
            fs = src.next()

    def writeInto(self, dest: BytesIO, tmpdir: Path = None):
        '''Build and write the archive into the given bytestream.
        tmpdir must be set if features specify included sources or binaries,
        and the relevant drvs must have been prefetched or prebuilt.
        '''
        strfeats = str.encode(self.features.print_features())
        featsinfo = tf.TarInfo('features')
        featsinfo.size = len(strfeats)
        with tf.open(fileobj=dest, mode='w|gz') as m:
            m.addfile(featsinfo, BytesIO(strfeats))
            for name, tgt in self.features.pinned_channels.items():
                self._push_channel(m, name, tgt)
            if self.features.include_sources:
                for f in tmpdir.joinpath(self.features.sources_drv).iterdir():
                    with tf.open(f, mode='r:*') as fm:
                        self.transplant(m, fm, 'sources')
            if self.features.include_bins:
                for f in tmpdir.joinpath(self.features.bins_drv).iterdir():
                    m.add(f)
