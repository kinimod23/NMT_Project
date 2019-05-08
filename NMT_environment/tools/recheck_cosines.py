#!/usr/bin/env python

# inputs params.00000 and params.best from sockeye
# outputs cosine distances in the form of a histogram

import sys
import numpy as np
import matplotlib.pyplot as plt
from scipy import spatial
import re

init = sys.argv[1]
best = sys.argv[2]


with open(init, "r") as f:
    src_init = f.read()

sinit = [x.strip() for x in src_init.split(']\n[')]
sinit=[re.sub('\n', "", vec) for vec in sinit]
sinit=[re.sub(r'\[ ', "", vec) for vec in sinit]
sinit=[re.sub(r'\]', "", vec) for vec in sinit]
sinit=[re.sub(r'\[', "", vec) for vec in sinit]
sinit=[re.sub(r'\s+', ",", vec) for vec in sinit]
sinit = [vec.split(',') for vec in sinit]


with open(best, "r") as f:
    src_best = f.read()

sbest = [x.strip() for x in src_best.split(']\n[')]
sbest=[re.sub('\n', "", vec) for vec in sbest]
sbest=[re.sub(r'\[ ', "", vec) for vec in sbest]
sbest=[re.sub(r'\]', "", vec) for vec in sbest]
sbest=[re.sub(r'\[', "", vec) for vec in sbest]
sbest=[re.sub(r'\s+', ",", vec) for vec in sbest]
sbest = [vec.split(',') for vec in sbest]


cosines=[]
for vec1, vec2 in zip(sinit, sbest):
	cos = spatial.distance.cosine(list(map(float,vec1)), list(map(float,vec2)))
	cosines.append(cos)


fig=plt.figure()
plt.hist(cosines, bins=20)
#plt.hist(cosines, bins=np.arange(0.0, 1.0, 0.05))
plt.xlabel('cosine distance')
plt.ylabel('amount of vectors')
plt.grid()
DPI = fig.get_dpi()
fig.set_size_inches(648/float(DPI),432/float(DPI))

plt.savefig(init.rsplit('/', 1)[-1][:9] + "_cosines.png")
