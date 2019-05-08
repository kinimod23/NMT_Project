#!/bin/bash

shell_scripts=`dirname "$0"`
base=$shell_scripts/..
pre_embs=$base/pre-trained_embs/glove

model_basel=$base/models/model_wmt17_basel
model_large=$base/models/model_wmt17_large.glove

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
python -m sockeye.extract_parameters --names "source_embed_weight" --output $pre_embs/basel.src_init.npz $model_basel/params.00000
python -m sockeye.extract_parameters --names "target_embed_weight" --output $pre_embs/basel.trg_init.npz $model_basel/params.00000
python -m sockeye.extract_parameters --names "source_embed_weight" --output $pre_embs/large.src_init.npz $model_large/params.00000
python -m sockeye.extract_parameters --names "target_embed_weight" --output $pre_embs/large.trg_init.npz $model_large/params.00000
echo "============================================================"
echo "extract best sockeye-nmt-system's embedding vectors"
echo "============================================================"
sleep 3
python -m sockeye.extract_parameters --names "source_embed_weight" --output $pre_embs/best.basel.src_init.npz $model_basel/params.best
python -m sockeye.extract_parameters --names "target_embed_weight" --output $pre_embs/best.basel.trg_init.npz $model_basel/params.best
python -m sockeye.extract_parameters --names "source_embed_weight" --output $pre_embs/best.large.src_init.npz $model_large/params.best
python -m sockeye.extract_parameters --names "target_embed_weight" --output $pre_embs/best.large.trg_init.npz $model_large/params.best
