#!/bin/sh
# nohup time -p bash  9-run_checkpoint_eval.sh 1 > reports/9-modi.txt & 

SCRIPTPATH=`pwd`
LANG=modi
HEADCOUNT=$1
mkdir -p $SCRIPTPATH/reports

# make traineddata files from last three checkpoints
rm data/$LANG/tessdata_fast/*.traineddata
ls -t data/$LANG/checkpoints/*.checkpoint | head -$HEADCOUNT > tmpcheckpoints
CHECKPOINT_FILES=tmpcheckpoints
while IFS= read -r TESTCHECK
do
    make traineddata MODEL_NAME=$LANG  CHECKPOINT_FILES=$TESTCHECK
done < "$CHECKPOINT_FILES"

TRAINEDDATAFILES=data/$LANG/tessdata_fast/*.traineddata
for TRAINEDDATA in $TRAINEDDATAFILES  ; do
     TRAINEDDATAFILE="$(basename -- $TRAINEDDATA)"
	echo $TRAINEDDATA
	echo $TRAINEDDATAFILE
	echo ${TRAINEDDATAFILE%.*}
      echo -e  "\n***** Modi *****   ${TRAINEDDATAFILE%.*}  \n"
           for PREFIX in $LANG ; do
			   FONTLIST=$SCRIPTPATH/langdata/$PREFIX.fontslist.txt
               LISTEVAL=$SCRIPTPATH/data/$PREFIX/list.eval
               REPORTSPATH=$SCRIPTPATH/reports/$PREFIX-eval-${TRAINEDDATAFILE%.*}
               rm -rf $REPORTSPATH
               mkdir $REPORTSPATH
               echo -e  "\n-----------------------------------------------------------------------------"  $PREFIX 
               while IFS= read -r FONTNAME
               do
                   ### echo "$SCRIPTPATH" > $REPORTSPATH/manifest-$PREFIX-${FONTNAME// /_}.log
                   echo -e  "\n------------------------------------------------------------------- Modi"  $PREFIX-${FONTNAME// /_}-${TRAINEDDATAFILE%.*}
                    while IFS= read -r LSTMFNAME
                    do
                        if [[ $LSTMFNAME == *${FONTNAME// /_}.* ]]; then
                            ### echo ${LSTMFNAME%.*}.tif >> $REPORTSPATH/manifest-$PREFIX-${FONTNAME// /_}.log
                            OMP_THREAD_LIMIT=1 tesseract ${LSTMFNAME%.*}.tif  ${LSTMFNAME%.*}-${TRAINEDDATAFILE%.*} --psm 6 --oem 1  -l  ${TRAINEDDATAFILE%.*}  --tessdata-dir $SCRIPTPATH/data/$LANG/tessdata_fast/  -c page_separator=''   1>/dev/null 2>&1
                            cat ${LSTMFNAME%.*}.gt.txt   >>  $REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt
                            cat ${LSTMFNAME%.*}-${TRAINEDDATAFILE%.*}.txt   >>  $REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt
                    fi
                done < $LISTEVAL
                 accuracy $REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt  $REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt  > $REPORTSPATH/report_${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt
	           java -cp ~/ocrevaluation/ocrevaluation.jar  eu.digitisation.Main  -gt "$REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt"  -ocr "$REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt"  -e UTF-8   -o "$REPORTSPATH/report_${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.html"    1>/dev/null 2>&1
                head -26 $REPORTSPATH/report_${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt
                cat $REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt  >> $REPORTSPATH/gt-$PREFIX-ALL.txt 
                cat $REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt >> $REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-ALL.txt 
                echo -e  "\n-----------------------------------------------------------------------------"  
            done < "$FONTLIST"
             accuracy $REPORTSPATH/gt-$PREFIX-ALL.txt  $REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-ALL.txt  > $REPORTSPATH/report_${TRAINEDDATAFILE%.*}-$PREFIX-ALL.txt
            java -cp ~/ocrevaluation/ocrevaluation.jar  eu.digitisation.Main  -gt "$REPORTSPATH/gt-$PREFIX-ALL.txt"  -ocr "$REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-ALL.txt"  -e UTF-8   -o "$REPORTSPATH/report_${TRAINEDDATAFILE%.*}-$PREFIX-ALL.html"      1>/dev/null 2>&1
            echo -e  "\n-----------------------------------------------------------------------------"  
        done 
        echo -e  "\n*************************************************************************"  
done
rm tmpcheckpoints

egrep 'Unassigned|Accuracy$|Digits|Punctuation' reports/9-$LANG.txt > reports/9-$LANG-summary.txt
