#!/bin/bash

shell_scripts=`dirname "$0"`
base=$shell_scripts/..
pre_embs=$base/pre-trained_embs/glove

model_name=$1
model=$base/models/"${model_name}"

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
echo "extract initial sockeye-nmt-system's embedding vectors"
echo "============================================================"
sleep 3

if [ "${model_name}" == 'model_wmt17_small.glove' ]; then
python -m sockeye.extract_parameters --names "source_embed_weight" --output $pre_embs/small.src_init.npz $model/params.00000
python -m sockeye.extract_parameters --names "target_embed_weight" --output $pre_embs/small.trg_init.npz $model/params.00000
  elif [ "${model_name}" == 'model_wmt17_large.glove' ]; then
  	python -m sockeye.extract_parameters --names "source_embed_weight" --output $pre_embs/large.src_init.npz $model/params.00000
  	python -m sockeye.extract_parameters --names "target_embed_weight" --output $pre_embs/large.trg_init.npz $model/params.00000
fi