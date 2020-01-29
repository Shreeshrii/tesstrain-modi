#!/bin/bash
# nohup bash  -x 7-trainmodi.sh  > 7-modi.log & 

SCRIPTPATH=`pwd`
MODEL=modi
LANG=mar

mkdir -p data/script  data/script/Devanagari data/$LANG
combine_tessdata -u ~/tessdata_best/script/Devanagari.traineddata $SCRIPTPATH/data/script/Devanagari/$MODEL.
combine_tessdata -u ~/tessdata_best/$LANG.traineddata $SCRIPTPATH/data/$LANG/$MODEL.

rm -rf data/$MODEL
mkdir data/$MODEL

cd data/$MODEL
wget -O $MODEL.config https://github.com/tesseract-ocr/langdata_lstm/raw/master/${LANG}/${LANG}.config
wget -O $MODEL.numbers https://github.com/tesseract-ocr/langdata_lstm/raw/master/${LANG}/${LANG}.numbers
wget -O $MODEL.punc https://github.com/tesseract-ocr/langdata_lstm/raw/master/${LANG}/${LANG}.punc
cp  $SCRIPTPATH/langdata/$MODEL.wordlist ./

Version_Str="$MODEL:shreeshrii`date +%Y%m%d`:from:"
sed -e "s/^/$Version_Str/" $SCRIPTPATH/data/script/Devanagari/$MODEL.version > $MODEL.version
sed -e "s/^/$Version_Str/" $SCRIPTPATH/data/$LANG/$MODEL.version > $MODEL.version

rm  /tmp/all-$MODEL-lstmf
fontlist=$SCRIPTPATH/langdata/$MODEL.fontslist.txt
while IFS= read -r fontname
     do
  	   find   $SCRIPTPATH/gt/$MODEL-${fontname// /_} -type f -name '*.lstmf' >  $SCRIPTPATH/data/all-$MODEL-${fontname// /_}-lstmf
        cat  $SCRIPTPATH/data/*${fontname// /_}*-lstmf >>  /tmp/all-$MODEL-lstmf
     done < "$fontlist"
python3 $SCRIPTPATH/shuffle.py 1 < /tmp/all-$MODEL-lstmf > all-lstmf

cat $SCRIPTPATH/langdata/$MODEL.training_text > all-gt 
sed -i  's/ј//g'  all-gt 
sed -i 's/љ//g'  all-gt 
sed -i 's/Ѱ//g'  all-gt 

cd ../..

make  training  \
MODEL_NAME=$MODEL  \
LANG_TYPE=Indic \
BUILD_TYPE=Layer  \
TESSDATA=$SCRIPTPATH/data \
GROUND_TRUTH_DIR=$SCRIPTPATH/gt/$1 \
START_MODEL=$LANG \
LAYER_NET_SPEC="[Lfx128 O1c1]" \
LAYER_APPEND_INDEX=5 \
RATIO_TRAIN=0.99 \
DEBUG_INTERVAL=-1 \
MAX_ITERATIONS=999999 > $MODEL.log & 
####
####lstmtraining \
####  --stop_training \
####  --convert_to_int \
####  --continue_from data/${MODEL}/checkpoints/${MODEL}Layer_checkpoint \
####  --traineddata $SCRIPTPATH/data/$MODEL/$MODEL.traineddata \
####  --model_output data/${MODEL}Layer_fast.traineddata
####
####OMP_THREAD_LIMIT=1   time -p  lstmeval  \
####  --model data/${MODEL}Layer_fast.traineddata \
####  --eval_listfile data/${MODEL}/list.eval \
####  --verbosity 0
####
####OMP_THREAD_LIMIT=1   time -p  lstmeval  \
####  --model data/${MODEL}Layer_fast.traineddata \
####  --eval_listfile data/${MODEL}/all-lstmf \
####  --verbosity 0
####