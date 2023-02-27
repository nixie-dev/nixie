import tarfile as tf
import re

from pathlib import Path
from io      import BytesIO
from .script import NixieFeatures
from os      import path

class ResourceTarball:
    '''An object representing the tarball appended to a Nixie-generated script.
    '''
    features: NixieFeatures
    original: tf.TarFile

    def __init__(self, origin: NixieFeatures | BytesIO):
        '''Construct the object, either from a generated NixieFeatures, or
        from an existing tarball buffer.
        '''
        if type(origin) is NixieFeatures:
            self.features = origin
        else:
            self.original = tf.open(fileobj=origin, mode='r:gz')
            self.features = NixieFeatures(self.original.extractfile('features'))
            mms = self.original.getmembers()
            chns = [ fi.name for fi in mms if re.match('^channels/[a-zA-Z0-9_-]+$', fi.name) ]
            self.features.pinned_channels = { k[9:]: None for k in chns }
            self.features.include_sources = 'sources' in [ m.name for m in mms ]
            self.features.include_bins = 'nix-static.Linux.x86_64' in [ m.name for m in mms ]

    def __del__(self):
        if self.original is not None:
            self.original.close()

    def _push_channel(self, m: tf.TarFile, name, tgt):
        '''Push a Nix channel into the archive, either from the specified path,
        or from the original archive in memory (if applicable)
        '''
        if tgt is not None:
            m.add(path.realpath(tgt), f'channels/{name}')
        else:
            mms = self.original.getmembers()
            chn = [ fi for fi in mms if re.match(f'^channels/{name}/.*', fi.name) ]
            for fil in chn:
                m.addfile(fil, self.original.extractfile(fil))

    def writeInto(self, dest: BytesIO):
        '''Build and write the archive into the given bytestream.
        '''
        strfeats = str.encode(self.features.print_features())
        featsinfo = tf.TarInfo('features')
        featsinfo.size = len(strfeats)
        with tf.open(fileobj=dest, mode='w|gz') as m:
            m.addfile(featsinfo, BytesIO(strfeats))
            for name, tgt in self.features.pinned_channels:
                _push_channel(m, name, tgt)

