#!/bin/bash

model_name=$1

if [ "${model_name}" == 'model_wmt17_basel' ]; then
	echo "============================================================"
	echo "download initial sockeye-nmt-system's embedding vectors..."
	echo "============================================================"
	sleep 3
	scp -r dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/basel.src_init.npz ~/Desktop/recheck_embs
	scp -r dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/basel.trg_init.npz ~/Desktop/recheck_embs
	echo "============================================================"
	echo "...and download sockeye's best checkpoint embedding vectors..."
	echo "============================================================"
	sleep 3
	scp -r dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/best.basel.src_init.npz ~/Desktop/recheck_embs
	scp -r dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/best.basel.trg_init.npz ~/Desktop/recheck_embs	
	echo "============================================================"
	echo "...and transform all elements into readable format"
	echo "============================================================"
	sleep 3
	python np_transf.py basel.src_init.npz
	python np_transf.py basel.trg_init.npz
	python np_transf.py best.basel.src_init.npz
	python np_transf.py best.basel.trg_init.npz
	rm basel.src_init.npz
	rm basel.trg_init.npz
	rm best.basel.src_init.npz
	rm best.basel.trg_init.npz	
	echo "--"
	echo "saved as .txt files"
	echo ""
fi
if [ "${model_name}" == 'model_wmt17_large.glove' ]; then
	echo "download en/de pre-trained vector elements for rechecking..."
	echo "============================================================"
	sleep 3
	scp dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/large.vecs.en.txt.npy ~/Desktop/recheck_embs/large.glove.en.npy
	scp dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/large.vecs.de.txt.npy ~/Desktop/recheck_embs/large.glove.de.npy
	echo "============================================================"
	echo "...and transform all elements into readable format"
	echo "============================================================"
	sleep 3
	python np_transf.py large.glove.en.npy
	python np_transf.py large.glove.de.npy
	rm large.glove.en.npy
	rm large.glove.de.npy
	echo "--"
	echo "saved as .txt files"
	echo ""
	echo "============================================================"
	echo "download initial sockeye-nmt-system's embedding vectors..."
	echo "============================================================"
	sleep 3
	scp -r dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/large.src_init.npz ~/Desktop/recheck_embs
	scp -r dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/large.trg_init.npz ~/Desktop/recheck_embs
	echo "============================================================"
	echo "...and download sockeye's best checkpoint embedding vectors..."
	echo "============================================================"
	sleep 3
	scp -r dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/best.large.src_init.npz ~/Desktop/recheck_embs
	scp -r dpfuetze@rattle.ifi.uzh.ch:~/NMT_Project/NMT_environment/pre-trained_embs/glove/best.large.trg_init.npz ~/Desktop/recheck_embs
	echo "============================================================"
	echo "...and transform all elements into readable format"
	echo "============================================================"
	sleep 3
	python np_transf.py large.src_init.npz
	python np_transf.py large.trg_init.npz
	python np_transf.py best.large.src_init.npz
	python np_transf.py best.large.trg_init.npz
	rm large.src_init.npz
	rm large.trg_init.npz
	rm best.large.src_init.npz
	rm best.large.trg_init.npz
	echo "--"
	echo "saved as .txt files"
	echo ""
fi