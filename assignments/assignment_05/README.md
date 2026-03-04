# Assignment 5: Write Once, Run on Everything - Bash Pipelines

**Vandana Kalithkar**  
03/02/2026  

## Command Log
### Task 1. Setup assignment_5/ directory

```bash
#------------------------- STARTING LOCALLY  --------------------------
# Start at SUPERCOMPUTER folder, I was already in the directory containing SUPERCOMPUTING
cd ~/SUPERCOMPUTING

# Sync with git
git pull

# Log onto HPC with SSH
bora
# Enter password
#------------------------------ VIA BORA  -----------------------------
# Within Bora, enter our directory
cd SUPERCOMPUTING/

# Sync with git
git pull

# Enter A5 directory, see what's within
cd assignments/assignment_05
ls

# Create the necessary folders and directories
mkdir scripts
mkdir log
mkdir data
cd data
mkdir raw
mkdir trimmed

# Adding data to .gitignore
cd
cd SUPERCOMPUTING

nano .gitignore

# Add the following lines to .gitignore to ignore the data from this assignment, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------
# Ignore data from assignment_05
assignments/assignment_05/data
assignments/assignment_05/log
# ------------------------------------------------------------

```
### Task 2. Script to download and prepare fastq data

```bash
# Move into scripts folder
cd assignments/assignment_05/

nano scripts/01_download_data.sh
# Add the following lines to 01_download_data.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------
#!/bin/bash
set -ueo pipefail
# ------------------------------------------------------------

cd ~/SUPERCOMPUTING/assignments/assignment_05/data/raw

# Download data package from git
wget https://gzahn.github.io/data/fastq_examples.tar
tar -xf fastq_examples.tar
rm fastq_examples.tar

echo "Install done!"

# Give executable permissions
chmod +x scripts/01_download_data.sh

# Run the script to ensure it works
bash ./scripts/01_download_data.sh
ls -R
```

### Task 3. Install and explore the fastp tool

```bash
# Enter programs folder
cd
cd programs

# Following instructions to install fastp lastest build
wget http://opengene.org/fastp/fastp
chmod a+x ./fastp
fastp # version 1.1.0
# programs is already in my $PATH, so I don't need to take any additional steps to make fastp accessible
cd
cd SUPERCOMPUTING/assignments/assignment_05

# Exploration 
fastp
fastp -i data/raw/6083_196_S200_R2_001.subset.fastq.gz -o data/trimmed/out.gz
fastp -i data/raw/6083_196_S200_R1_001.subset.fastq.gz \
      -I data/raw/6083_196_S200_R2_001.subset.fastq.gz \
      -o data/trimmed/out_R1.gz \
      -O data/trimmed/out_R2.gz

ls -R # Output files create as expected

# Log files got added to A5 dir, remove
rm *.html *.json

# Remove the trimmed data 
rm data/trimmed/*
```

### Task 4. Script to run fastp

```bash
# Make the fastp run script
nano scripts/02_run_fastp.sh

# Add the following lines to 02_run_fastp.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------
#!/bin/bash
# Make a var for fwd input file by taking user input for the data path
FWD_IN=$1

# Make a var for the reverse input file by replacing R1 with R2 (fwd into rev)
REV_IN=${FWD_IN/_R1_/_R2_}

# Make a temp var for the fwd and rev output file by adding the trimmed indicator to the filenames >
FWD_OUT_1=${FWD_IN/.fastq.gz/.trimmed.fastq.gz}
REV_OUT_1=${REV_IN/.fastq.gz/.trimmed.fastq.gz}

# Move the temp out files from raw to trimmed data dir
FWD_OUT=${FWD_OUT_1/raw/trimmed}
REV_OUT=${REV_OUT_1/raw/trimmed}

# Create temp Report name by removing the end of the original user file, and then change dir name t>
REPORT_1=${FWD_IN/_R1_001.subset.fastq.gz/_log.html}
REPORT=${REPORT_1/data\/raw/log}

echo $FWD_IN $REV_IN $FWD_OUT $REV_OUT $REPORT

# Run fastp command
fastp \
--in1 ${FWD_IN} --in2 ${REV_IN} \
--out1 ${FWD_OUT} --out2 ${REV_OUT} \
--json /dev/null --html ${REPORT} \
--trim_front1 8 --trim_front2 8 --trim_tail1 20 --trim_tail2 20 \
--n_base_limit 0 \
--length_required 100 \
--average_qual 20
# ------------------------------------------------------------

# Make script 02 executable
chmod +x 02_run_fastp.sh

echo "export PATH=$PATH:${HOME}/SUPERCOMPUTING/assignments_assignment_05/scripts" >> ~/.bashrc

# Try out script
./scripts/02_run_fastp.sh ./data/raw/6083_001_S1_R1_001.subset.fastq.gz

ls -R

# It seemed to have worked as expected, clear the A5 dir of everything except the raw data
rm data/trimmed/*
rm log/*
```

### Task 5. `pipeline.sh` script

```bash
# Within A5 dir, make the pipeline script
nano pipeline.sh

# Add the following lines to pipeline.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------
#!/bin/bash
set -euo pipefail

# Run the download and data prep script
bash ./scripts/01_download_data.sh

# For each raw data file, loop through and run second script
for FILE in ./data/raw/*_R1_*
        do echo "Processing $FILE"
        bash ./scripts/02_run_fastp.sh "$FILE"
        done

echo "Complete!"
# ------------------------------------------------------------
chmod +x pipeline.sh
```

### Task 6. Delete all the data files and start over

```bash
# Clear all raw data files to start fresh
rm data/raw/*

# Try to run the pipeline
bash pipeline.sh

# See if it worked
ls -R 

```

### Task 7. Document Everything in README.md

Reflection:

### Task 8. Push to GitHub

```bash
git add -A
git commit -m"A5 README update"
git push

```

