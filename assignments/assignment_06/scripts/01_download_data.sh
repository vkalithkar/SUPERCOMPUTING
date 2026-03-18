#!/bin/bash
set -ueo pipefail

# Move into the directory where the data needs to be installed (Only make the data dir if it's not already there)
mkdir -p ./data/
cd ./data/

# Download the data
wget -O SRR33939694.fastq.gz "https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1"

# Unzip the data
gunzip SRR33939694.fastq.gz 

