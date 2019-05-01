#!/usr/bin/env python

# inputs original glove embeddings and params.00000
# outputs if all glove embeddings are found in sockeye's embedding layer and if not how many

import sys

nmt_init = sys.argv[1]
glove_init = sys.argv[2]

with open(nmt_init, "r") as f:
    nmt = f.readlines()

with open(glove_init, "r") as f:
    glove = f.readlines()

intersections = set(nmt) & set(glove)

if len(intersections) == len(glove):
	print("All pre-trained GloVe vectors were found in the sockeye embedding layer.")

elif len(intersections) != len(glove):
	missing=(len(glove)-len(intersections))
	print(str(int(missing))+" pre-trained GloVe vector lines out of "+str(len(glove))+" were mising in the sockeye embedding layer.")
