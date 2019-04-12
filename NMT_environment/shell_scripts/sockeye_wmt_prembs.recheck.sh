#!/bin/bash

shell_scripts=`dirname "$0"`
base=$shell_scripts/..
models=$base/models/model_wmt17_glove
pre_embs=$base/pre-trained_embs/glove

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
python -m sockeye.extract_parameters --names "source_embed_weight" --output $pre_embs/src_init.npz $models/params.00000
python -m sockeye.extract_parameters --names "target_embed_weight" --output $pre_embs/trg_init.npz $models/params.00000