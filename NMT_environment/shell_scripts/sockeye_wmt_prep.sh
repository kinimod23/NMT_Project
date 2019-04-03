#!/bin/bash

shell_scripts=`dirname "$0"`
base=$shell_scripts/..

data=$base/data

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
echo "split corpus into training, validation and test set"
echo "============================================================"
sleep 3


head -n 2000 $data/corpus.tc.de > $data/test.de
head -n 2000 $data/corpus.tc.en > $data/test.en
echo "test set finished"

head -n 4000 $data/corpus.tc.de | tail -n 25000 > $data/val.de
head -n 4000 $data/corpus.tc.en | tail -n 25000 > $data/val.en
echo "validation set finished"

tail -n 5846458 $data/corpus.tc.de > $data/train.de
tail -n 5846458 $data/corpus.tc.en > $data/train.en
echo "training set finished"


echo "============================================================"
echo "build BPE vocabulary on whole data set"
echo "============================================================"
sleep 3
subword-nmt learn-joint-bpe-and-vocab --input $data/train.de $data/train.en \
                                    -s 30000 \
                                    -o $data/bpe.codes \
                                    --write-vocabulary $data/bpe.vocab.de $data/bpe.vocab.en
echo "--"
echo "BPE vocabulary successfully built"
echo ""

echo "============================================================"
echo "use BPE vocabulary to apply on training set"
echo "============================================================"
sleep 3
subword-nmt apply-bpe -c $data/bpe.codes --vocabulary $data/bpe.vocab.de --vocabulary-threshold 50 < $data/train.de > $data/train.BPE.de
subword-nmt apply-bpe -c $data/bpe.codes --vocabulary $data/bpe.vocab.en --vocabulary-threshold 50 < $data/train.en > $data/train.BPE.en
echo "--"
echo "BPE vocabulary successfully applied on training set"
echo ""
echo "============================================================"
echo "use BPE vocabulary to apply on validation set"
echo "============================================================"
sleep 3
subword-nmt apply-bpe -c $data/bpe.codes --vocabulary $data/bpe.vocab.de --vocabulary-threshold 50 < $data/val.de > $data/val.BPE.de
subword-nmt apply-bpe -c $data/bpe.codes --vocabulary $data/bpe.vocab.en --vocabulary-threshold 50 < $data/val.en > $data/val.BPE.en
echo "--"
echo "BPE vocabulary successfully applied on validation set"
echo ""
echo "============================================================"
echo "use BPE vocabulary to apply on test set"
echo "============================================================"
sleep 3
subword-nmt apply-bpe -c $data/bpe.codes --vocabulary $data/bpe.vocab.de --vocabulary-threshold 50 < $data/test.de > $data/test.BPE.de
subword-nmt apply-bpe -c $data/bpe.codes --vocabulary $data/bpe.vocab.en --vocabulary-threshold 50 < $data/test.en > $data/test.BPE.en
echo "--"
echo "BPE vocabulary successfully applied on test set"
echo ""




