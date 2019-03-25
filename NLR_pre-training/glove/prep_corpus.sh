#!/bin/bash

glove=`dirname "$0"`
master=$glove/../..
base=$master/NMT_environment
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
echo "prepare source corpus into glove readable format"
echo "============================================================"
sleep 2
python wmt_prep.py $data/corpus.tc.en
echo "--"
echo "source corpus is prepared and saved"
echo ""
echo "============================================================"
echo "prepare target corpus into glove readable format"
echo "============================================================"
sleep 2
python wmt_prep.py $data/corpus.tc.de
echo "--"
echo "target corpus is prepared and saved"
echo ""