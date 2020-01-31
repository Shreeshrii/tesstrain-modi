# tesstrain-modi

Finetune Training and OCR evaluation of Tesseract 5.0.0 Alpha for [Marathi in Modi script](https://en.wikipedia.org/wiki/Modi_script) using
 [tesstrain Training workflow for Tesseract 4 as a Makefile](https://github.com/tesseract-ocr/tesstrain). 
Certain file locations and scripts have been modified compared to source repos.

OCR evaluation is done using [ISRI Analytic Tools for OCR Evaluation with UTF-8 support](https://github.com/eddieantonio/ocreval). 

This effort is in response to this [query in tesseract-ocr forum.](https://groups.google.com/d/msgid/tesseract-ocr/f2fe2399-e6d4-4a7e-886e-7337176e2304%40googlegroups.com.)

## modi - Marathi in Modi script

Replace the top layer training is being done using [2 fonts](https://github.com/Shreeshrii/tesstrain-modi/blob/master/langdata/modi.fontslist.txt). The [training text](https://github.com/Shreeshrii/tesstrain-modi/blob/master/langdata/modi.training_text) includes some punctuation and Modi digits/numbers.

