#!/bin/bash

signi=`dirname "$0"`
base=$signi/..

echo "============================================================"
echo "avtivate virtual environment"
echo "============================================================"
sleep 2
source $base/NMT_environment/venvs/sockeye_wmt_env/bin/activate
if [[ "$VIRTUAL_ENV" != "" ]]; then 
    echo "You are in a working virtualenv $VIRTUAL_ENV"
else
	echo "ERROR: Please activate the virtualenv first!"
	exit 
fi
sleep 5
echo "============================================================"
echo "download tool for significance testing"
echo "============================================================"
echo "# written by Graham Neubig, customised by Mathias Müller"
sleep 3
wget https://raw.githubusercontent.com/bricksdont/util-scripts/master/paired-bootstrap.py
echo "============================================================"
echo "copy gold standard & translated test sets during evaluation"
echo "============================================================"
sleep 3
cp ~/NMT_Project/NMT_environment/data/test.de $signi/test.gold.de
cp ~/NMT_Project/NMT_environment/translations/test.model_wmt17_basel.de $signi/test.transl.basel.de
cp ~/NMT_Project/NMT_environment/translations/test.model_wmt17_small.glove.de $signi/test.transl.small.glove.de
cp ~/NMT_Project/NMT_environment/translations/test.model_wmt17_large.glove.de $signi/test.transl.large.glove.de
echo "--"
echo "the environment for significance testing is set up"
echo ""
sleep 5