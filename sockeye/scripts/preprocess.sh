#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data

mkdir -p $base/shared_models

src=de
trg=en

# cloned from https://github.com/bricksdont/moses-scripts
MOSES=$base/tools/moses-scripts/scripts

bpe_num_operations=10000
bpe_vocab_threshold=10

TMP=/var/tmp

#################################################################

# fix original test set (has wrong carriage return characters)

cat $data/test.$src | perl -pE 's/(\^M|\r)//g' > $TMP/test.$src
cat $data/test.$trg | perl -pE 's/(\^M|\r)//g' > $TMP/test.$trg

cp $TMP/test.$src $data/test.$src
cp $TMP/test.$trg $data/test.$trg

rm $TMP/test.$src $TMP/test.$trg

# normalize train, dev and test

for corpus in train dev test; do
	cat $data/$corpus.$src | sed -e "s/\r//g" | perl $MOSES/tokenizer/normalize-punctuation.perl > $data/$corpus.normalized.$src
	cat $data/$corpus.$trg | sed -e "s/\r//g" | perl $MOSES/tokenizer/normalize-punctuation.perl > $data/$corpus.normalized.$trg
done

# tokenize train, dev and test

for corpus in train dev test; do
	cat $data/$corpus.normalized.$src | perl $MOSES/tokenizer/tokenizer.perl -a -q -l $src > $data/$corpus.tokenized.$src
	cat $data/$corpus.normalized.$trg | perl $MOSES/tokenizer/tokenizer.perl -a -q -l $trg > $data/$corpus.tokenized.$trg
done

# clean length and ratio of train (only train!)

$MOSES/training/clean-corpus-n.perl $data/train.tokenized $src $trg $data/train.tokenized.clean 1 80

# learn truecase model on train (learn one model for each language)

$MOSES/recaser/train-truecaser.perl -corpus $data/train.tokenized.clean.$src -model $base/shared_models/truecase-model.$src
$MOSES/recaser/train-truecaser.perl -corpus $data/train.tokenized.clean.$trg -model $base/shared_models/truecase-model.$trg

# apply truecase model to train, test and dev

for corpus in train; do
	$MOSES/recaser/truecase.perl -model $base/shared_models/truecase-model.$src < $data/$corpus.tokenized.clean.$src > $data/$corpus.truecased.$src
	$MOSES/recaser/truecase.perl -model $base/shared_models/truecase-model.$trg < $data/$corpus.tokenized.clean.$trg > $data/$corpus.truecased.$trg
done

for corpus in dev test; do
        $MOSES/recaser/truecase.perl -model $base/shared_models/truecase-model.$src < $data/$corpus.tokenized.$src > $data/$corpus.truecased.$src
        $MOSES/recaser/truecase.perl -model $base/shared_models/truecase-model.$trg < $data/$corpus.tokenized.$trg > $data/$corpus.truecased.$trg
done

# learn BPE model on train (concatenate both languages)

subword-nmt learn-joint-bpe-and-vocab -i $data/train.truecased.$src $data/train.truecased.$trg \
	--write-vocabulary $base/shared_models/vocab.$src $base/shared_models/vocab.$trg \
	-s $bpe_num_operations -o $base/shared_models/$src$trg.bpe

# apply BPE model to train, test and dev

for corpus in train dev test; do
	subword-nmt apply-bpe -c $base/shared_models/$src$trg.bpe --vocabulary $base/shared_models/vocab.$src --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus.truecased.$src > $data/$corpus.bpe.$src
	subword-nmt apply-bpe -c $base/shared_models/$src$trg.bpe --vocabulary $base/shared_models/vocab.$trg --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus.truecased.$trg > $data/$corpus.bpe.$trg
done

# file sizes
for corpus in train dev test; do
	echo "corpus: "$corpus
	wc -l $data/$corpus.bpe.$src $data/$corpus.bpe.$trg
done

# sanity checks

echo "At this point, please check that 1) file sizes are as expected, 2) languages are correct and 3) material is still parallel"
