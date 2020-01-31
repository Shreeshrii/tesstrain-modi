# tesstrain-modi

Finetune Training and OCR evaluation of Tesseract 5.0.0 Alpha for [Marathi in Modi script](https://en.wikipedia.org/wiki/Modi_script) using
 [tesstrain Training workflow for Tesseract 4 as a Makefile](https://github.com/tesseract-ocr/tesstrain). 
Certain file locations and scripts have been modified compared to source repos.

OCR evaluation is done using [ISRI Analytic Tools for OCR Evaluation with UTF-8 support](https://github.com/eddieantonio/ocreval) and [The ocrevalUAtion tool](https://sites.google.com/site/textdigitisation/ocrevaluation).

This effort is in response to this [query in tesseract-ocr forum.](https://groups.google.com/d/msgid/tesseract-ocr/f2fe2399-e6d4-4a7e-886e-7337176e2304%40googlegroups.com.)

## modi - Marathi in Modi script

This finetune training for Modi from Marathi is using synthetic training data in 2 unicode fonts. However, since most Modi documents are handwritten in cursive style, the training should preferably be augmented  with scanned images of real life documents.

Replace the top layer training is being done using [2 fonts](https://github.com/Shreeshrii/tesstrain-modi/blob/master/langdata/modi.fontslist.txt). The [training text](https://github.com/Shreeshrii/tesstrain-modi/blob/master/langdata/modi.training_text) includes some punctuation and Modi digits/numbers. 

### Training Steps

* Training text was extracted from [Tesseract's Marathi training text ](https://github.com/tesseract-ocr/langdata_lstm/blob/master/mar/mar.training_text).  

* Unigram and Bigram lists were generating using [create_dictdata from pytesstrain](https://github.com/wincentbalin/pytesstrain). `grep` and `sed` [scripts](0-maketext.sh) were used to choose lines from training text so as to:
    * include a minimum set of for each bigram as far as possible.
     * deleted unwanted characters based on unigram frequency list.

* This Marathi text in Devanagari text was converted to Modi script using [Aksharamukha](https://aksharamukha.appspot.com/upload/).

* text2image and tesseract were used to create lstmf files from the training text and fonts. 
    * mulipage tif with single line on each page to get the degrade and distortion effects
    * 20 lines/pages in each tif

