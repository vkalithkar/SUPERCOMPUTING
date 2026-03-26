#!/bin/bash
#SBATCH --job-name=assignment_07
#SBATCH --nodes=1 # how many physical machines in the cluster
#SBATCH --ntasks=1 # how many separate 'tasks' (stick to 1)
#SBATCH --cpus-per-task=8 # how many cores (bora max is 20)
#SBATCH --time=12:00:00 # d-hh:mm:ss or just No. of minutes
#SBATCH --mem=48G # how much physical memory (all by default)
#SBATCH --mail-type=FAIL,BEGIN,END # when to email you
#SBATCH --mail-user=vkalithkar@wm.edu # who to email
#SBATCH -o output/assignment_07.out #STDOUT to file (%j is jobID)
#SBATCH -e output/assignment_07.err #STDERR to file (%j is jobID)

set -ueo pipefail

# 1. Download data
echo "Step 1: Downloading SRA data and reference genome"
bash scripts/01_download_data.sh 

# 2. Clean reads (Quality control)
echo "Step 2: Running quality control on reads"
bash scripts/02_clean_reads.sh

# 3. Map & Filter
echo "Step 3: Aligning to reference genome + filtering matches"
bash scripts/03_map_reads.sh

echo "Full A7 Pipeline Execution Finished."
