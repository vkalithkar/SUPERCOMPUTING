#!/bin/bash
#SBATCH --job-name=lambdaphage
#SBATCH --nodes=1 # how many physical machines in the cluster
#SBATCH --ntasks=1 # how many separate 'tasks' (stick to 1)
#SBATCH --cpus-per-task=20 # how many cores (bora max is 20)
#SBATCH --time=2 # d-hh:mm:ss or just No. of minutes
#SBATCH --mem=128G # how much physical memory (all by default)
#SBATCH --mail-type=FAIL,BEGIN,END # when to email you
#SBATCH --mail-user=vkalithkar@wm.edu # who to email
#SBATCH -o phage_%j.out #STDOUT to file (%j is jobID)
#SBATCH -e phage_%j.err #STDERR to file (%j is jobID)


./scripts/run_bbmap.sh
