#!/bin/bash
# Make a var for fwd input file by taking user input for the data path
FWD_IN=$1

# Make a var for the reverse input file by replacing R1 with R2 (fwd into rev)
REV_IN=${FWD_IN/_R1_/_R2_}

# Make a temp var for the fwd and rev output file by adding the trimmed indicator to the filenames from input
FWD_OUT_1=${FWD_IN/.fastq.gz/.trimmed.fastq.gz}
REV_OUT_1=${REV_IN/.fastq.gz/.trimmed.fastq.gz}

# Move the temp out files from raw to trimmed data dir
FWD_OUT=${FWD_OUT_1/raw/trimmed}
REV_OUT=${REV_OUT_1/raw/trimmed}

# Create temp Report name by removing the end of the original user file, and then change dir name to log
REPORT_1=${FWD_IN/_R1_001.subset.fastq.gz/_log.html} 
REPORT=${REPORT_1/data\/raw/log}

echo $FWD_IN $REV_IN $FWD_OUT $REV_OUT $REPORT

# Run fastp command
fastp \
--in1 ${FWD_IN} --in2 ${REV_IN} \
--out1 ${FWD_OUT} --out2 ${REV_OUT} \
--json /dev/null --html ${REPORT} \
--trim_front1 8 --trim_front2 8 --trim_tail1 20 --trim_tail2 20 \
--n_base_limit 0 \
--length_required 100 \
--average_qual 20
