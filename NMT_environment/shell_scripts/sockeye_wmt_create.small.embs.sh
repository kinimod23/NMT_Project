#!/bin/bash

shell_scripts=`dirname "$0"`
base=$shell_scripts/..
data=$base/data
tools=$base/tools
pre_embs=$base/pre-trained_embs/glove
params=$base/pre-trained_embs/params.init_small.glove

##################################

echo "============================================================"
echo "avtivate virtual environment"
echo "============================================================"
sleep 2
source $base/venvs/sockeye_wmt_env/bin/activate
if [[ "$VIRTUAL_ENV" != "" ]]; then 
    echo "You are in a working virtualenv $VIRTUAL_ENV"
else
        echo "ERROR: Please activate the virtualenv first!"
        exit 
fi
sleep 5
echo "============================================================"
echo "extract vocabulary from training data"
echo "============================================================"
sleep 2
python -m sockeye.vocab \
          -i $data/train.BPE.en \
          -o $data/small.vocab.src.0.json
echo "--"
echo "source vocabulary extracted"
echo ""
sleep 3
python3 -m sockeye.vocab \
          -i $data/train.BPE.de \
          -o $data/small.vocab.tgt.0.json
echo "--"
echo "target vocabulary extracted"
echo ""

echo "============================================================"
echo "convert pre-trained embs into sockeye.init_embedding format"
echo "============================================================"
sleep 2
python $tools/vec2npy.py \
		$pre_embs/small.vecs.en.txt \
		$pre_embs/small.vecs.en.txt
echo "--"
echo "pre-trained source embeddings converted successfully"
echo ""

python $tools/vec2npy.py \
		$pre_embs/small.vecs.de.txt \
		$pre_embs/small.vecs.de.txt
echo "--"
echo "pre-trained target embeddings converted successfully"
echo ""
echo "============================================================"
echo "initialize pre-trained embedding matrix for final NMT training"
echo "============================================================"
sleep 2
python -m sockeye.init_embedding \
  -w $pre_embs/small.vecs.en.txt.npy $pre_embs/small.vecs.de.txt.npy \
  -i $pre_embs/small.vecs.en.txt.vocab $pre_embs/small.vecs.de.txt.vocab \
  -o $data/small.vocab.src.0.json $data/small.vocab.tgt.0.json \
  -n source_embed_weight target_embed_weight \
  -f $params


