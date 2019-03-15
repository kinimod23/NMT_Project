# Neural Machine Translation Project Module

* ELMo https://arxiv.org/pdf/1802.05365
* doc2vec https://arxiv.org/pdf/1405.4053
* zalando http://www.aclweb.org/anthology/C18-1139
* GloVe http://www.aclweb.org/anthology/D14-1162
* Evaluation methods http://www.aclweb.org/anthology/D15-1036
* Intrinsic Evaluation http://www.aclweb.org/anthology/W16-2507
* preprocessing steps and hyperparameter settings http://www.aclweb.org/anthology/Q15-1016
* Europarl Corpus http://www.statmt.org/europarl/ \\ http://www.aclweb.org/anthology/E17-2038


![Alt text](../master/pre-trained_embs//nlr_analysis.png?raw=true "NLRs to analyse")

----------------------------------------------------------------------------------------------
## ToDo
* train a sockeye NMT model with pre-trained glove embeddings on the Europarl corpus

* overcome challenges with other Embeddings to be able to train them on sockeye too

----------------------------------------------------------------------------------------
## What I have done
* successfully run a NMT toy model using sockeye
* implemented glove, zalando, elmo and paragraph-vector NLRs
	* for all there are still some challenges to overcome except of glove
* written clear Exposé with goals of this project
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
Europarl Corpus http://www.statmt.org/europarl/ \\ http://www.aclweb.org/anthology/E17-2038

#### Which specific steps (e.g. milestones) are you going to take towards solving the problem? What's the schedule?
* 20.12.2018 - Write part 4 and implement NLRs 
* 31.12.2018 - Building an NMT network
* 06.01.2019 - Input NLRs into NMT network
* 07.01 till 03.02.2019 - Problem fixing and paper writing 
* 29.03.2019 - Submission

------------------------------------------------------------------------------------------
