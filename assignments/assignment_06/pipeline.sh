#!/bin/bash
set -ueo pipefail

# Set up directories 
BASE_DIR=$(pwd)

# Download data
bash ${BASE_DIR}/scripts/01_download_data.sh
echo "Data downloaded."

# Set up local build
bash ${BASE_DIR}/scripts/02_flye_2.9.6_manual_build.sh
echo "Local build done."

# Set up conda env
bash ${BASE_DIR}/scripts/02_flye_2.9.6_conda_install.sh 
echo "Conda environment set up."

# Run the 3 Flye scripts in 3 different envs
bash ${BASE_DIR}/scripts/03_run_flye_conda.sh
echo "Conda run done."

bash ${BASE_DIR}/scripts/03_run_flye_module.sh
echo "Module run done."

bash ${BASE_DIR}/scripts/03_run_flye_local.sh
echo "Local run done."

echo "------------------------------------------------------------"

echo "REPORTING STATS"
tail -n 10 $(find ${BASE_DIR}/assemblies -name "*.log") 

echo "------------------------------------------------------------"


