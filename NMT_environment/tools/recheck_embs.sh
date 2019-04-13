#!/bin/bash

echo "============================================================"
echo "download en/de pre-trained vector elements for rechecking..."
echo "============================================================"
sleep 3
scp dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/vecs.en.txt.npy ~/Desktop/recheck_embs/glove.en.npy
scp dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/vecs.de.txt.npy ~/Desktop/recheck_embs/glove.de.npy
echo "============================================================"
echo "...and transform first 1000 elements into readable format"
echo "============================================================"
sleep 3
python np_transf.py glove.en.npy
python np_transf.py glove.de.npy
echo "--"
echo "saved as .txt files"
echo ""
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
python np_transf.py src_init.npz
python np_transf.py trg_init.npz
echo "--"
echo "saved as .txt files"
echo ""