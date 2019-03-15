#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

tools=$base/tools
mkdir -p $tools

echo "Make sure this script is executed AFTER you have activated a virtualenv"

# install Sockeye

pip install sockeye==1.18.72 matplotlib mxboard

# install BPE library

pip install subword-nmt

# alternatively:
#git clone https://github.com/rsennrich/subword-nmt $tools/subword-nmt

# install sacrebleu for evaluation

pip install sacrebleu

# install Moses scripts for preprocessing

git clone https://github.com/bricksdont/moses-scripts $tools/moses-scripts

