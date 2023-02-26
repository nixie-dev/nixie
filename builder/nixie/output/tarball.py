import tarfile as tf

from pathlib import Path
from io      import BytesIO
from .script import NixieFeatures

class ResourceTarball:
    features: NixieFeatures

    def __init__(self, tarball: BytesIO = None):
        if tarball is not None:
            with tf.open(fileobj=tarball, mode='r|gz') as m:
                pass

    def useFeatures(self, features: NixieFeatures):
        self.features = features

    def writeInto(self, dest: BytesIO):
        strfeats = str.encode(self.features.print_features())
        featsinfo = tf.TarInfo('features')
        featsinfo.size = len(strfeats)
        with tf.open(fileobj=dest, mode='w|gz') as m:
            m.addfile(featsinfo, BytesIO(strfeats))
