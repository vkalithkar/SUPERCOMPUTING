#!/bin/bash
set -ueo pipefail

# Enter conda env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate vk-ncbi-env

# Set up absolute path directories from A7 dir
BASE_DIR=$(pwd)
DATA_DIR="${BASE_DIR}/data"

DOG_DATA_DIR="${DATA_DIR}/dog_reference"
RAW_DIR="${DATA_DIR}/raw"
CLEAN_DIR="${DATA_DIR}/clean"

mkdir -p ${CLEAN_DIR}  

# Loop through pairs of raw reads, use fastp to clean
for FWD_IN in ${RAW_DIR}/*_1.fastq; do

    # Var for the reverse input file by replacing 1 with 2 (fwd to rev)
    REV_IN="${FWD_IN/_1.fastq/_2.fastq}"

    # Make a temp var for the fwd and rev output file by adding the trimmed indicator to the filenames from input
    FWD_OUT="${FWD_IN/\/raw\//\/clean\/}"
    REV_OUT="${REV_IN/\/raw\//\/clean\/}"

    # Run fastp command, leaving trimming, n_base_limit, length_reqired as default
    fastp \
    --in1 ${FWD_IN} \
    --in2 ${REV_IN} \
    --out1 ${FWD_OUT} \
    --out2 ${REV_OUT} \
    --json /dev/null \
    --html /dev/null  \
    --average_qual 20
done

# Deactivate conda env
conda deactivate
