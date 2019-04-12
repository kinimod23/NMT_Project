#!/bin/bash

echo "============================================================"
echo "download first 1000 pre-trained vector elements for rechecking"
echo "============================================================"
sleep 3
ssh dpfuetze@rattle.ifi.uzh.ch 'head -n 1000 ~/NMT_Project/NMT_environment/pre-trained_embs/glove/vecs.en.txt' > ~/Desktop/recheck_embs/vecs.en.txt
ssh dpfuetze@rattle.ifi.uzh.ch 'head -n 1000 ~/NMT_Project/NMT_environment/pre-trained_embs/glove/vecs.de.txt' > ~/Desktop/recheck_embs/vecs.de.txt
echo "============================================================"
echo "download initial sockeye-nmt-system's embedding vectors..."
echo "============================================================"
sleep 3
scp -r dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/src_init.npz ~/Desktop/recheck_embs
scp -r dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/trg_init.npz ~/Desktop/recheck_embs
echo "============================================================"
echo "...and transform first 1000 elements into readable format"
echo "============================================================"
sleep 3
python npz_transf.py src_init.npz
python npz_transf.py trg_init.npz