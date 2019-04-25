#!/bin/bash

signi=`dirname "$0"`
base=$signi/..

model_name=$1
GOLD=$2
SYS1=$3
SYS2=$4

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
echo "compute descriptive statistics and save to txt file"
echo "============================================================"
sleep 3
python paired-bootstrap.py 	--num_samples 100 --eval_type bleu_detok \
							$signi/$GOLD $signi/$SYS1 $signi/$SYS2 \
							> $signi/d.stats_$model_name.txt
echo "--"
echo "successfully saved descriptive statistics to d.stats_"${model_name}".txt"
echo ""
sleep 3