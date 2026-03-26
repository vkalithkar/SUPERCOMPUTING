#!/bin/bash
set -ueo pipefail

# Enter conda env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate vk-ncbi-env

# Set up absolute path directories from A7 dir
BASE_DIR=$(pwd)
DATA_DIR="${BASE_DIR}/data"
OUT_DIR="${BASE_DIR}/output"

DOG_DATA_DIR="${DATA_DIR}/dog_reference"
RAW_DIR="${DATA_DIR}/raw"
CLEAN_DIR="${DATA_DIR}/clean"
# CLEAN_DIR="${BASE_DIR}/data/small_clean"

mkdir -p ${OUT_DIR}  

DOG_GENOME="${DOG_DATA_DIR}/dog_reference_genome.fna"

# Loop through the clean reads
for FWD_IN in ${CLEAN_DIR}/*_1.fastq; do
    # Var for reverse input file (fwd to rev)
    REV_IN="${FWD_IN/_1.fastq/_2.fastq}"

    # Get the base name for that sample
    SAMPLE=$(basename ${FWD_IN} _1.fastq)

    # Where alignment results will be saved for full sample 
    FULL_SAM="${OUT_DIR}/${SAMPLE}.sam"

    # Where alignment results will be saved for those reads mapped to dog genome 
    MATCH_SAM="${OUT_DIR}/${SAMPLE}_dog-matches.sam"

    # Run bbmap to map
    bbmap.sh \
        ref=${DOG_GENOME} \
        in1=${FWD_IN} \
        in2=${REV_IN} \
        out=${FULL_SAM} \
        minid=0.95 \
        -Xmx28g
    
    samtools view -S -F 4 ${FULL_SAM} > ${MATCH_SAM} 
    
done

rm -rf ${BASE_DIR}/ref

# Deactivate conda env
conda deactivate
