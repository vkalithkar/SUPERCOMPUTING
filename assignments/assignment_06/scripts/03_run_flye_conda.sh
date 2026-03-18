#!/bin/bash
set -ueo pipefail

# Set up env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate flye-env

# Set up absolute path directories
BASE_DIR=$(pwd)
OUT_DIR="${BASE_DIR}/assemblies/assembly_conda"
DATA_DIR="${BASE_DIR}/data"

# Create the output dir in case it doesn't exist
mkdir -p ${OUT_DIR}

# Run the flye command
flye --nano-hq ${DATA_DIR}/SRR33939694.fastq \
     --genome-size 150k \
     --out-dir ${OUT_DIR} \
     --threads 4

# Clean up the output bloat
rm -rf ${OUT_DIR}/00-assembly/ ${OUT_DIR}/10-consensus/ ${OUT_DIR}/20-repeat/ ${OUT_DIR}/30-contigger/ ${OUT_DIR}/40-polishing/
rm ${OUT_DIR}/assembly_graph* ${OUT_DIR}/assembly_info.txt ${OUT_DIR}/params.json

# Rename the files
mv ${OUT_DIR}/assembly.fasta ${OUT_DIR}/conda_assembly.fasta
mv ${OUT_DIR}/flye.log ${OUT_DIR}/conda_flye.log

# Deactivate this env
conda deactivate
