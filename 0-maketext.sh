#!/bin/bash
rm tmp*
cp ~/langdata_lstm/mar/mar.training_text  MODI.txt
python3 ~/tesstrain/normalize.py -v MODI.txt
par 200l < MODI.txt > tmp1.txt
shuf tmp1.txt > MODI.txt
cat ./bigrams.txt| while IFS="
" read target; do grep -F -m 50 "$target"  MODI.txt  ; done > tmp3.txt
sort -u tmp3.txt   > tmp3-sorted.txt
create_dictdata -i  tmp3-sorted.txt -d ./ -l MODI
rm  tmp*
