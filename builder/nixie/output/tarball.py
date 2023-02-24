import tarfile as tf

from pathlib import Path
from .script import NixieFeatures
from io      import BytesIO

class ResourceTarball:
    features: NixieFeatures

    def __init__(self, feats: NixieFeatures):
        self.features = feats

    def writeInto(self, dest: BytesIO):
        with tf.open(fileobj=dest, mode='w|gz') as m:
            pass
