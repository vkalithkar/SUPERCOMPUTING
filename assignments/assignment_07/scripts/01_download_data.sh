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

mkdir -p ${DOG_DATA_DIR} ${RAW_DIR} 

# Get all raw fastq data from "Run" column via fasterq-dump
for ACC_NUM in $(tail -n +2 data/SraRunTable.csv | cut -d "," -f 1); do
    fasterq-dump ${ACC_NUM} \
    -O ${RAW_DIR} \
    --split-files
done

echo "All raw data downloaded."

# Download Canis familiaris referene genome via datasets
datasets download genome taxon "canis familiaris" --reference --filename ${DOG_DATA_DIR}/dog_reference_genome.zip

# Unzip to the correct dir
unzip -n ${DOG_DATA_DIR}/dog_reference_genome.zip -d ${DOG_DATA_DIR}

# Clean up the files it made 
rm ${DOG_DATA_DIR}/md5sum.txt ${DOG_DATA_DIR}/README.md ${DOG_DATA_DIR}/dog_reference_genome.zip

# Rename and move the reference genome
mv ${DOG_DATA_DIR}/ncbi_dataset/data/GCF_011100685.1/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fna ${DOG_DATA_DIR}/dog_reference_genome.fna

# Delete the remainder of the ncbi data dir 
rm -rf ${DOG_DATA_DIR}/ncbi_dataset

# Deactivate conda env
conda deactivate
