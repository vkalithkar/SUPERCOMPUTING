# Assignment 3: Exploring DNA sequence file with command line tools

**Vandana Kalithkar**  
02/14/2026  

## Command Log
### Task 1: Navigate to your assignment_3/ directory and set it up
```bash
#------------------------- STARTING LOCALLY  --------------------------
# Start at SUPERCOMPUTER folder, I was already in the directory containing SUPERCOMPUTING
cd ~/SUPERCOMPUTING

# Sync with git
git pull

# Enter assignment directory
cd assignments/assignment_03/

# Data folder doesn't exist, create directory
mkdir data

# Return to SUPERCOMPUTING directory
cd ..
cd ..

# Add assignment_02 data folder to .gitignore
nano .gitignore

# Add this line to the .gitignore, save, exit
assignments/assignment_03/data

# Push changes to git
git add -A
git commit -m "modified .gitignore to ignore A3 data"
git push
```
### Task 2: Download a fasta sequence file using wget

```bash
# Log onto HPC with SSH
bora
# Enter password

#------------------------------ VIA BORA  -----------------------------

# Within Bora, enter our directory
cd SUPERCOMPUTING/

# Sync with git
git pull

# Enter assignment directory
cd assignments/assignment_03/

# Data folder doesn't exist (it's ignored), create directory and enter
mkdir data
cd data

# Install the data with wget
wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz

# Check to see if it's there, it has .gz extension
ls

# Unzip
gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz

# Check to see if it's unzipped, it has .fna extension
ls

```
### Task 3: Use Unix tools to explore the file contents

```bash

# Enter back into SUPERCOMPUTING on bora

#1 
#vk - start in bora A3/data



```
### Task 5: Write a reflection in your README.md
