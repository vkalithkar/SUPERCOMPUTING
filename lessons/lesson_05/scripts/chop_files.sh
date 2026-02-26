#!/bin/bash
set -ueo pipefail

# set project directory where files are found
# this is mine, but you will have to change it to the correct location for your project
MAIN_DIR="/sciclone/home/vkalithkar/SUPERCOMPUTING/lessons/lesson_05"

# go to that location
cd $MAIN_DIR

# whatever commands got you a working for-loop
for FWD in data/*_R1_*
do REV=${FWD/_R1_/_R2_}
OUT=${FWD%_L001_R1_sample.fastq}_interleaved_chop_${1}.fastq
echo $FWD $REV $OUT
./scripts/interleave_chop.sh $FWD $REV $OUT $1
done

