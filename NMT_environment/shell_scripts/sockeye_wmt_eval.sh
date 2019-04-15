#!/bin/bash

shell_scripts=`dirname "$0"`
base=$shell_scripts/..
data=$base/data
translations=$base/translations
mkdir -p $translations
tools=$base/tools

MOSES=$base/tools/moses-scripts/scripts

model_name=$1
num_threads=5

src=en
trg=de

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
echo "translating from source to target on test data"
echo "============================================================"
sleep 3
OMP_NUM_THREADS=$num_threads python -m sockeye.translate \
				-i $data/test.BPE.$src \
				-o $translations/test.BPE.$model_name.$trg \
				-m $base/models/$model_name \
				--beam-size 10 \
				--length-penalty-alpha 1.0 \
				--device-ids 5 \
				--batch-size 100
echo "============================================================"
echo "rebuild original data"
echo "============================================================"
sleep 5
echo "============================================================"
echo "undo BPE"
echo "============================================================"
sleep 3
cat $translations/test.BPE.$model_name.$trg | sed 's/\@\@ //g' > $translations/test.truecased.$model_name.$trg
echo "============================================================"
echo "undo truecasing"
echo "============================================================"
sleep 3
cat $translations/test.truecased.$model_name.$trg | $MOSES/recaser/detruecase.perl > $translations/test.tokenized.$model_name.$trg
echo "============================================================"
echo "undo tokenisation"
echo "============================================================"
sleep 3
cat $translations/test.tokenized.$model_name.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $translations/test.$model_name.$trg
echo "============================================================"
echo "compute BLEU and save scores to txt file"
echo "============================================================"
sleep 3
cat $translations/test.$model_name.$trg | sacrebleu $data/test.$trg > $translations/BLEU_$model_name.txt


