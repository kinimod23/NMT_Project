#! /bin/bash


scripts=`dirname "$0"`
base=$scripts/..

mkdir -p $base/models

num_threads=5
model_name=model_200k

##################################

OMP_NUM_THREADS=$num_threads python -m sockeye.train \
			-s $base/data/train.bpe.de \
			-t $base/data/train.bpe.en \
			-vs $base/data/dev.bpe.de \
                        -vt $base/data/dev.bpe.en \
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
			--max-num-checkpoint-not-improved 8
