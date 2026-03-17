#!/bin/bash
set -ueo pipefail

# Move into the directory where the data needs to be installed
cd ~/SUPERCOMPUTING/assignments/assignment_06/data/

# Download the data
wget -O SRR33939694.fastq.gz "https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1"

# Unzip the data
gunzip SRR33939694.fastq.gz 

