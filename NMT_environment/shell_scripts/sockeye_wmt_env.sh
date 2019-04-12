#!/bin/bash

shell_scripts=`dirname "$0"`
base=$shell_scripts/..
mkdir -p $base/venvs

echo "============================================================"
echo "creating a NMT virtual environment"
echo "============================================================"
sleep 2
virtualenv -p python3 $base/venvs/sockeye_wmt_env
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
echo "installing necessary packages into the virtual environment"
sleep 5
echo "============================================================"
echo "install sockeye and the BPE library"
echo "============================================================"
sleep 2
wget https://raw.githubusercontent.com/awslabs/sockeye/master/requirements/requirements.gpu-cu80.txt
pip install sockeye --no-deps -r requirements.gpu-cu80.txt
rm requirements.gpu-cu80.txt
pip install subword_nmt
echo "============================================================"
echo "install evaluation tool to value results after training"
echo "============================================================"
sleep 2
pip install sacrebleu
echo "--"
echo "all necessary packages are installed into the virtual env"
echo ""
sleep 5
echo "============================================================"
echo "download corpus and unzip it"
echo "============================================================"
sleep 2

data=$base/data
mkdir -p $data

wget http://data.statmt.org/wmt17/translation-task/preprocessed/de-en/corpus.tc.de.gz -P $data
wget http://data.statmt.org/wmt17/translation-task/preprocessed/de-en/corpus.tc.en.gz -P $data
gunzip $data/corpus.tc.de.gz
gunzip $data/corpus.tc.en.gz
echo "--"
echo "the NMT environment is set up"
echo ""
sleep 5