# Neural Machine Translation Project Module

* ELMo https://arxiv.org/pdf/1802.05365
* doc2vec https://arxiv.org/pdf/1405.4053
* zalando http://www.aclweb.org/anthology/C18-1139
* GloVe http://www.aclweb.org/anthology/D14-1162
* Evaluation methods http://www.aclweb.org/anthology/D15-1036
* Intrinsic Evaluation http://www.aclweb.org/anthology/W16-2507
* preprocessing steps and hyperparameter settings http://www.aclweb.org/anthology/Q15-1016
* WMT 2017 Translation Task http://www.statmt.org/wmt17/
* Data used: http://data.statmt.org/wmt17/translation-task/preprocessed/de-en/
* Additional Data used: http://www.statmt.org/wmt14/training-monolingual-news-crawl/

----------------------------------------------------------------------------------------------

![Alt text](../master/NLR_pre-training//nlr_analysis.png?raw=true "NLRs to analyse")

----------------------------------------------------------------------------------------------
## Training Steps

Clone this repository in the desired place:

    git clone https://github.com/kinimod23/NMT_Project.git
    cd ~/NMT_Project/NMT_environment/shell_scripts

Set up the NMT environment:

    bash sockeye_wmt_env.sh

Preprocess the data used:

    bash sockeye_wmt_prep.sh

Pre-train glove embeddings:

    cd ~/NMT_Project/NLR_pre-training/glove

Download and install glove components:

    git init .
    git remote add -t \* -f origin http://github.com/stanfordnlp/glove
    git checkout master
    make

Train glove embeddings with previously generated BPE training data:

    # for source
    bash glove_small.training.sh ~/NMT_Project/NMT_environment/data/train.BPE.en
    # for target
    bash glove_small.training.sh ~/NMT_Project/NMT_environment/data/train.BPE.de

Initialize pre-trained embedding matrix for final NMT training:

    cd ~/NMT_Project/NMT_environment/shell_scripts
    bash sockeye_wmt_create.small.embs.sh

Final NMT training - Baseline (with insulated Embeddings):

    bash sockeye_wmt_train_basel.sh

Final NMT training - Experiment (with pre-trained Embeddings):

    bash sockeye_wmt_train_small.prembs.sh model_wmt17_small.glove


## Evaluation Steps

Using test data for Evaluation

    cd ~/NMT_Project/NMT_environment/shell_scripts
    # Evaluation of baseline model
    bash sockeye_wmt_eval.sh model_wmt17_basel
    # Evaluation of glove model
    bash sockeye_wmt_eval.sh model_wmt17_small.glove
\
\
Doing a recheck if the initially used vectors of the sockeye-nmt-system are actually conform with the pre-trained vectors (and not Zero as being the usual "sockeye way")

[1] extract initial sockeye-nmt-system's embedding vectors

    bash sockeye_wmt_prembs.recheck.sh && exit

[2] on local machine

    mkdir ~/Desktop/recheck_embs
    cd ~/Desktop/recheck_embs
    wget https://raw.githubusercontent.com/kinimod23/NMT_Project/master/NMT_environment/tools/np_transf.py
    wget https://raw.githubusercontent.com/kinimod23/NMT_Project/master/NMT_environment/tools/recheck_embs.sh

[3] download and transform vectors for rechecking

    bash recheck_embs.sh

[4] manually compare pre-trained vs. initially used vectors


## Additional Steps (caution: overwrites BPE training data and glove vectors from previous steps)
### Use more data to pre-train glove embeddings

    cd ~/NMT_Project/NMT_environment/shell_scripts
    bash sockeye_wmt_prep_add.data

Train glove embeddings with previously generated additional BPE training data:

    cd ~/NMT_Project/NLR_pre-training/glove
    # for source
    bash glove_large.training.sh ~/NMT_Project/NMT_environment/data/pre-train_data/pre-train.BPE.en
    # for target
    bash glove_large.training.sh ~/NMT_Project/NMT_environment/data/pre-train_data/pre-train.BPE.de

Initialize pre-trained embedding matrix for final NMT training:

    cd ~/NMT_Project/NMT_environment/shell_scripts
    bash sockeye_wmt_create.large.embs.sh

Final NMT training - Experiment (with pre-trained Embeddings):

    bash sockeye_wmt_train_large.prembs.sh model_wmt17_large.glove

----------------------------------------------------------------------------------------------

## ToDo
* pre-train embeddings on more/different data

* evaluation of how much embeddings change from params.00000 to params.best
    * compare translation quality when pre-trained embeddings are fixed from start to end

* interpreting BLEU results: train several systems to calculate mean and variance

----------------------------------------------------------------------------------------
## What I have done
* evaluation of pre-trained vs. initial sockeye-nmt-system's embedding vectors

* evaluation via BLEU score

* sockeye NMT model trained with glove embeddings on the wmt'17 corpus

* glove embeddings trained on BPE-Units

* successfully run a NMT toy model using sockeye

* implemented glove, zalando, elmo and paragraph-vector NLRs
	* for all there are still some challenges to overcome except of glove
	
* written Exposé with goals of this project
    * Literature survey on Research Questions

---------------------------------------------------------------------------------------------------

### Project Organisation

#### A short memorable project title.
An Evaluation of different Natural Language Representations by using an identical Neural Machine Translation Network

#### What is the problem you want to address? How do you determine whether you have solved it?
To categorise distinct approaches (character/word/sentence/thought input) for generating word embeddings.
By using a translation task (from English to German), it's clear to see which approach performs best.

Research Questions:
a) Which is the best lexical input (character, word, sentence, thought) to generate language representations for a translation task?
b) Which is the best Language Model (bi-directional, one-directional, etc.) to use for generating language representations applied to a translation task?

#### How is this going to translate into a computational linguistics problem?
Natural language Representations (NLRs) might ignore key features of distributional semantics! A new NLR model is typically evaluated across several tasks, and is considered an improvement if it achieves better accuracy than its predecessors. However, different applications rely on different aspects of word embeddings, and good performance in one application does not necessarily imply equally good performance on another.

#### Which data are you planning to use?
WMT 2017 Translation Task http://data.statmt.org/wmt17/translation-task/preprocessed/de-en/

------------------------------------------------------------------------------------------
