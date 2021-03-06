#!/bin/bash

unicodefontdir=/home/ubuntu/.fonts/modi
MODEL=modinew
numlines=20
fontlist=langdata/modi.fontslist.txt
traininginput=langdata/$MODEL.training_text

fontcount=$(wc -l < "$fontlist")
linecount=$(wc -l < "$traininginput")
perfontcount=$(( linecount / fontcount))
numfiles=$(( perfontcount / numlines))

# files created by script during processing
trainingtext=/tmp/$MODEL-train.txt
fonttext=/tmp/$MODEL-file-train.txt
linetext=/tmp/$MODEL-line-train.txt

cp ${traininginput} ${trainingtext} 
 
 while IFS= read -r fontname
     do
        prefix=gt/$MODEL-"${fontname// /_}"
        rm -rf ${prefix}
        mkdir  ${prefix} 
        head -$perfontcount ${trainingtext} > ${fonttext}
        sed -i  "1,$perfontcount d"  ${trainingtext}
        for cnt in $(seq 1 $numfiles) ; do
            head -$numlines ${fonttext} > ${linetext}
             sed -i  "1,$numlines  d"  ${fonttext}
             last=${cnt: -1}
             case "$last" in
                  1)    let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=300  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp   --degrade_image=false
                       ;;
                  2)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=300  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp   --degrade_image=true
                       ;;
                  3)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=300  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp --degrade_image=true  --distort_image     --invert=false   
                       ;;
                  4)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=300  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp  --degrade_image=true  --distort_image     --invert=false   
                       ;;
                  5)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=150  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp   --degrade_image=true
                       ;;
                  6)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=150  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp   --degrade_image=true   
                       ;;
                  7)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=200  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp   --degrade_image=false 
                       ;;
                  8)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=200  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp    --degrade_image=true   
                       ;;
                  9)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=200  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp   --degrade_image=true --distort_image     --invert=false 
                       ;;
                  0)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=200  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp  --degrade_image=true   --distort_image     --invert=false   
                       ;;
                  *) echo "Signal number $last is not processed"
                     ;;
             esac
             OMP_THREAD_LIMIT=1 tesseract "$prefix"/"${fontname// /_}.$cnt.exp$exp".tif "$prefix"/"${fontname// /_}.$cnt.exp$exp"  --psm 6 --dpi 150 lstm.train
             python3 generate_gt_from_charbox.py -b "$prefix"/${fontname// /_}.$cnt.exp$exp.box -t  "$prefix"/${fontname// /_}.$cnt.exp$exp.gt.txt
         done
		 find ${prefix} -type f -name '*.lstmf' > data/all-$MODEL-${fontname// /_}-lstmf
     done < "$fontlist"
