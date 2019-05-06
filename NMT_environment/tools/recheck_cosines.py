#!/usr/bin/env python

# inputs params.00000 and params.best from sockeye
# outputs cosine distances in the form of a histogram

import sys
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
	# cosine distance
	#cos = spatial.distance.cosine(list(map(float,vec1)), list(map(float,vec2)))	
	#cosine similarity
	cos = 1 - spatial.distance.cosine(list(map(float,vec1)), list(map(float,vec2)))
	cosines.append(cos)


fig=plt.figure()
# cosine distance
#plt.hist(cosines, bins=[0.0, 0.1, 0.2, 0.3, 0.4, 0.5])
# cosine similarity
plt.hist(cosines, bins=[0.5, 0.6, 0.7, 0.8, 0.9, 1.0])
plt.xlabel('cosine similarity')
plt.ylabel('amount of vectors')
plt.grid()
DPI = fig.get_dpi()
fig.set_size_inches(648/float(DPI),432/float(DPI))

plt.savefig(init.rsplit('/', 1)[-1][:9] + "_cosinesim.png")
