#!/bin/bash

shell_scripts=`dirname "$0"`
base=$shell_scripts/..
data=$base/data

mkdir -p $base/tools/shared_models
mkdir -p $data/pre-train_data

pre_data=$data/pre-train_data

MOSES=$base/tools/moses-scripts/scripts

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
echo "download additional data"
echo "============================================================"
sleep 3
wget http://www.statmt.org/wmt14/training-monolingual-news-crawl/news.2012.en.shuffled.gz -P $pre_data
wget http://www.statmt.org/wmt14/training-monolingual-news-crawl/news.2012.de.shuffled.gz -P $pre_data
gunzip $pre_data/news.2012.en.shuffled.gz
gunzip $pre_data/news.2012.de.shuffled.gz
echo "--"
echo "downloaded and unzipped additional data"
echo ""
echo "============================================================"
echo "normalise data"
echo "============================================================"
sleep 3
cat $pre_data/news.2012.en.shuffled | sed -e "s/\r//g" | perl $MOSES/tokenizer/normalize-punctuation.perl > $pre_data/n12.norm.en
cat $pre_data/news.2012.de.shuffled | sed -e "s/\r//g" | perl $MOSES/tokenizer/normalize-punctuation.perl > $pre_data/n12.norm.de
echo "--"
echo "data successfully normalised"
echo ""
echo "============================================================"
echo "tokenise data"
echo "============================================================"
sleep 3
cat $pre_data/n12.norm.en | perl $MOSES/tokenizer/tokenizer.perl -a -q -l en > $pre_data/n12.tok.en
cat $pre_data/n12.norm.de | perl $MOSES/tokenizer/tokenizer.perl -a -q -l de > $pre_data/n12.tok.de
echo "--"
echo "data successfully tokenised"
echo ""
echo "============================================================"
echo "detruecase (old) bilingual data"
echo "============================================================"
cat $data/corpus.tc.en | $MOSES/recaser/detruecase.perl > $pre_data/detruec.tc.en
cat $data/corpus.tc.de | $MOSES/recaser/detruecase.perl > $pre_data/detruec.tc.de
echo "--"
echo "old data successfully detruecased"
echo ""
echo "============================================================"
echo "concatenate additional data to original corpus"
echo "============================================================"
sleep 3
cat $pre_data/detruec.tc.en $pre_data/n12.tok.en > $data/pre-train_data/add.n12.tc_det.en
cat $pre_data/detruec.tc.de $pre_data/n12.tok.en > $data/pre-train_data/add.n12.tc_det.de
echo "--"
echo "two datasets are concatenated together"
echo ""
echo "============================================================"
echo "learn truecase model"
echo "============================================================"
sleep 3
$MOSES/recaser/train-truecaser.perl -corpus $pre_data/add.n12.tc_det.en -model $base/tools/shared_models/truecase-model.en
$MOSES/recaser/train-truecaser.perl -corpus $pre_data/add.n12.tc_det.de -model $base/tools/shared_models/truecase-model.de
echo "--"
echo "truecase model learned for concatenated data"
echo ""
echo "============================================================"
echo "apply truecase model"
echo "============================================================"
sleep 3
$MOSES/recaser/truecase.perl -model $base/tools/shared_models/truecase-model.en < $pre_data/add.n12.tc_det.en > $pre_data/add.n12.tc.en
$MOSES/recaser/truecase.perl -model $base/tools/shared_models/truecase-model.de < $pre_data/add.n12.tc_det.de > $pre_data/add.n12.tc.de
echo "--"
echo "data successfully truecased"
echo ""
echo "============================================================"
echo "use old BPE vocabulary to apply on training set for glove training"
echo "============================================================"
sleep 3
subword-nmt apply-bpe -c $data/bpe.codes --vocabulary $data/bpe.vocab.de --vocabulary-threshold 50 < $pre_data/add.n12.tc.de > $pre_data/pre-train.BPE.de
subword-nmt apply-bpe -c $data/bpe.codes --vocabulary $data/bpe.vocab.en --vocabulary-threshold 50 < $pre_data/add.n12.tc.en > $pre_data/pre-train.BPE.en
echo "--"
echo "BPE vocabulary successfully applied on huge dataset for pre-training glove"
echo ""



#optional second approach with learning BPE on bilingual + monolingual data instead of only bilingual data

:'
echo "============================================================"
echo "build BPE vocabulary on training data"
echo "============================================================"
sleep 3
subword-nmt learn-joint-bpe-and-vocab --input $pre_data/add.n12.tc.de $pre_data/add.n12.tc.en \
                                    -s 30000 \
                                    -o $pre_data/bpe.codes \
                                    --write-vocabulary $pre_data/bpe.vocab.de $pre_data/bpe.vocab.en
echo "--"
echo "BPE vocabulary successfully built"
echo ""

echo "============================================================"
echo "use BPE vocabulary to apply on training set for glove training"
echo "============================================================"
sleep 3
subword-nmt apply-bpe -c $pre_data/bpe.codes --vocabulary $pre_data/bpe.vocab.de --vocabulary-threshold 50 < $pre_data/add.n12.tc.de > $pre_data/pre-train.BPE.de
subword-nmt apply-bpe -c $pre_data/bpe.codes --vocabulary $pre_data/bpe.vocab.en --vocabulary-threshold 50 < $pre_data/add.n12.tc.en > $pre_data/pre-train.BPE.en
echo "--"
echo "BPE vocabulary successfully applied on huge dataset for pre-training glove"
echo ""

echo "============================================================"
echo "use BPE vocabulary to apply on NMT training set"
echo "============================================================"
sleep 3
subword-nmt apply-bpe -c $pre_data/bpe.codes --vocabulary $pre_data/bpe.vocab.de --vocabulary-threshold 50 < $data/train.de > $pre_data/train.BPE.de
subword-nmt apply-bpe -c $pre_data/bpe.codes --vocabulary $pre_data/bpe.vocab.en --vocabulary-threshold 50 < $data/train.en > $pre_data/train.BPE.en
echo "--"
echo "BPE vocabulary successfully applied on training set"
echo ""
echo "============================================================"
echo "use BPE vocabulary to apply on NMT validation set"
echo "============================================================"
sleep 3
subword-nmt apply-bpe -c $pre_data/bpe.codes --vocabulary $pre_data/bpe.vocab.de --vocabulary-threshold 50 < $data/val.de > $pre_data/val.BPE.de
subword-nmt apply-bpe -c $pre_data/bpe.codes --vocabulary $pre_data/bpe.vocab.en --vocabulary-threshold 50 < $data/val.en > $pre_data/val.BPE.en
echo "--"
echo "BPE vocabulary successfully applied on validation set"
echo ""
echo "============================================================"
echo "use BPE vocabulary to apply on NMT test set"
echo "============================================================"
sleep 3
subword-nmt apply-bpe -c $pre_data/bpe.codes --vocabulary $pre_data/bpe.vocab.de --vocabulary-threshold 50 < $data/test.de > $pre_data/test.BPE.de
subword-nmt apply-bpe -c $pre_data/bpe.codes --vocabulary $pre_data/bpe.vocab.en --vocabulary-threshold 50 < $data/test.en > $pre_data/test.BPE.en
echo "--"
echo "BPE vocabulary successfully applied on test set"
echo ""




#rm $data/corpus.tc.en
#rm $data/corpus.tc.de

