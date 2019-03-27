#!/bin/bash

shell_scripts=`dirname "$0"`
base=$shell_scripts/..
data=$base/data

mkdir -p $base/models

num_threads=5
model_name=model_wmt17_glove

embs=$base/pre_trained_embs/params.init_glove

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
echo "split source/target sentences into subsplits and serialize in matrix format"
echo "============================================================"
echo "--"
echo "# this step helps to limit memory usage and hence the training time needed"
echo ""
sleep 5
python -m sockeye.prepare_data \
                        -s $data/train.BPE.en \
                        -t $data/train.BPE.de \
                        -o $data/train_data

#rm $data/train.BPE.de
#rm $data/train.BPE.en


echo "============================================================"
echo "START TRAINING"
echo "============================================================"
sleep 8
nohup OMP_NUM_THREADS=$num_threads python -m sockeye.train \
                        -d train_data \
                        -vs $data/val.BPE.en \
                        -vt $data/val.BPE.de \
                        --encoder rnn \
                        --decoder rnn \
                        --num-embed 256 \
                        --num-layers 1:1 \
                        --checkpoint-frequency 4000 \
                        --rnn-num-hidden 512 \
                        --rnn-attention-type dot \
                        --max-seq-len 80 \
                        --decode-and-evaluate 500 \
                        --decode-and-evaluate-use-cpu \
                        -o $base/models/$model_name \
                        --device-ids 0 \
                        --max-num-checkpoint-not-improved 8 \
                        --params $embs \
                        --allow-missing-params
