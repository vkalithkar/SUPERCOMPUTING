#!/bin/bash
set -ueo pipefail

cd ~/SUPERCOMPUTING/assignments/assignment_05/data/raw

# Download data package from git
wget https://gzahn.github.io/data/fastq_examples.tar
tar -xf fastq_examples.tar
rm fastq_examples.tar

echo "Install done!"

