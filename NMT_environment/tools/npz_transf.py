#!/usr/bin/env python

# Converts npz to readable array

import numpy as np
import sys

npz_file = sys.argv[1]

if npz_file.rsplit('/', 1)[-1] == "src_init.npz":
	with np.load(npz_file) as data:
		arr = data['source_embed_weight']
elif npz_file.rsplit('/', 1)[-1] == "trg_init.npz":
	with np.load(npz_file) as data:
   		arr = data['target_embed_weight']

a = arr[:1000]

with open("transf_" + npz_file.rsplit('/', 1)[-1][:-4] + ".txt", "w", encoding="utf-8") as file:
    for item in list(a):
        file.write("%s\n" % item)