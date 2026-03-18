#!/bin/bash
set -ueo pipefail

# Needs to be run from assignment 6 dir

module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

# Create and activate 
mamba create -y -n flye-env flye=2.9.6 -c bioconda

conda activate flye-env
conda env export --no-builds > flye-env.yml
conda deactivate

echo "Conda env flye-env built successfully."




