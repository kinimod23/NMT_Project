#!/usr/bin/env python

# Converts npz to readable array

import numpy as np
import sys

np_file = sys.argv[1]

if np_file.rsplit('/', 1)[-1][-4:] == ".npz":
	if np_file.rsplit('/', 1)[-1] == "src_init.npz":
		with np.load(np_file) as data:
			arr = data['source_embed_weight']
	elif np_file.rsplit('/', 1)[-1] == "trg_init.npz":
		with np.load(np_file) as data:
   			arr = data['target_embed_weight']

elif np_file.rsplit('/', 1)[-1][-4:] == ".npy":
	arr = np.load(np_file)

a = arr[:1000]

with open(np_file.rsplit('/', 1)[-1][:-4] + ".txt", "w", encoding="utf-8") as file:
    for item in list(a):
        file.write("%s\n" % item)