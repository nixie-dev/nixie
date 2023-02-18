#!/usr/bin/env python3

import tarfile as tf
import sys
from re import sub

with tf.open(sys.argv[1], mode='r:gz') as m:
    with tf.open(sys.argv[2], mode='x:gz') as n:
        for fs in m.getmembers():
            n.addfile(tf.TarInfo(
                sub("^[a-zA-Z0-9-.]*/", "%s/" %sys.argv[3], fs.name)
            ), m.extractfile(fs))
