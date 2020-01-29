# tesstrain-hindi-impact

Demo of Training workflow for Tesseract 4 for Finetune for Impact training for Hindi
using the tesstrain makefile for training with 
2 sets of page images with their transcription provided by [Jaspreet Kaur](https://groups.google.com/forum/#!searchin/tesseract-ocr/jaspreet%7Csort:date/tesseract-ocr/6AZzpvu4Qlw/rroYPZ3jBQAJ). 

## leptonica, tesseract

You will need a recent version (>= 4.0.0beta1) of tesseract built with the
training tools and matching leptonica bindings.
[Build](https://github.com/tesseract-ocr/tesseract/wiki/Compiling)
[instructions](https://github.com/tesseract-ocr/tesseract/wiki/Compiling-%E2%80%93-GitInstallation)
and more can be found in the [Tesseract project
wiki](https://github.com/tesseract-ocr/tesseract/wiki/).

## tesstrain

This repo uses a modified version of Makefile from [tesstrain](https://github.com/tesseract-ocr/tesstrain) alongwith some bash scripts to run Finetune training.

For tesstrain, single line images and their corresponding ground truth transcription is used. This repo uses page level images and their transcription.

## Finetune training for Impact 

[Finetune for impact process described as part of tesstutorial](https://github.com/tesseract-ocr/tesseract/wiki/TrainingTesseract-4.00#fine-tuning-for-impact) is meant for finetuning the traineddata for a single font. This repo uses images with same typeface (instead of training text and font) for the training.

* First step - [1-makewordstrbox.sh](1-makewordstrbox.sh) - makes wordstrbox and lstmf files from page images and their transcription.
* Second step - [2-trainimpact.sh](2-trainimpact.sh) - sets up the files required for training, runs lstmtraining and lstmeval.

## Finetune training for Impact using jaspreet1 and jaspreet2

`runall.sh` runs both the above steps for a set of image files and their transcriptions.

* Run the command ` bash runall.sh jaspreet1`
* See [log file](eval-jaspreet1.log) for messages during the run for `jaspreet1` images.

* Run the command ` bash runall.sh jaspreet2`
* See [log file](eval-jaspreet2.log) for messages during the run for `jaspreet2` images.

### Results of training (limited training data - probably overfitted)

#### jaspreet1

* tessdata_best/hin - At iteration 0, stage 0, Eval Char error rate=1.7447785, Word error rate=3.5978507
* tessdata_best/script/Devanagari - At iteration 0, stage 0, Eval Char error rate=1.3114632, Word error rate=4.003367
* hinjaspreet1Impact - At iteration 0, stage 0, Eval Char error rate=0, Word error rate=0

[finetuned trainedata](https://github.com/Shreeshrii/tesstrain-hindi-impact/blob/master/data/hinjaspreet1Impact_fast.traineddata) 
can be used for reognizing images.

#### jaspreet2 

* tessdata_best/hin - At iteration 0, stage 0, Eval Char error rate=3.5434626, Word error rate=9.6305108
* tessdata_best/script/Devanagari - At iteration 0, stage 0, Eval Char error rate=2.6841831, Word error rate=7.2226686
* hinjaspreet2Impact - At iteration 0, stage 0, Eval Char error rate=0.23175537, Word error rate=0.81453783

[finetuned trainedata](https://github.com/Shreeshrii/tesstrain-hindi-impact/blob/master/data/hinjaspreet2Impact_fast.traineddata)
can be used for reognizing images.

## To test Finetune for Impact training for test image

* Run the command ` bash runall.sh test`

## To do Finetune training with your images

* Make a new folder eg. `mytraining`
* Put (.png) images and their matching groundtruth transcription (.gt.txt) in the folder (preferably 100-200 lines)
* Run the command ` bash runall.sh mytraining` (will run training for 400 iterations).

## License

Software is provided under the terms of the `Apache 2.0` license.
