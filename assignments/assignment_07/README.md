# Assignment 7: SLURM Job Submission & Public Data

**Vandana Kalithkar**  
03/25/2026  

## Command Log
### Task 1. Setup assignment_7/ directory

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

nano .gitignore
# Add the following lines to .gitignore to ignore the data from this assignment, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------
# Ignore data from assignment_07
assignments/assignment_07/data/clean
assignments/assignment_07/data/raw
assignments/assignment_07/data/dog_reference
# ------------------------------------------------------------

# Enter A7 dir
cd assignments/assignment_07

# Make the folders, the rest are made in subsequent steps
mkdir data scripts output
mkdir data/raw data/clean data/dog_reference
```
### Task 2. Download Sequence Data
```bash
# https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA1073697&o=acc_s%3Aa&s=SRR27883923,SRR27883937,SRR27883924 - bioproject with dog feces metagenomics 
# Downloaded only 10 SRR metadata via run selector into one .csv file called SraRunTable.csv
# Placed into assignment_07/data/ folder via Filezilla

# Set up conda env - Needs to be run from assignment 7 dir
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

# Create and activate conda env with sra-tools 
mamba create -y -n vk-ncbi-env sra-tools -c bioconda
conda activate vk-ncbi-env

# Verify install + one more package I forgot
fasterq-dump --version
conda install -y ncbi-datasets-cli -c bioconda
datasets --help

# Export to config, deactivate
conda env export --no-builds > vk-ncbi-env.yml
conda deactivate

# Script to get data
nano scripts/01_download_data.sh

# Add the following lines to 01_download_data.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------
#!/bin/bash
set -ueo pipefail

# Enter conda env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate vk-ncbi-env

# Set up absolute path directories from A7 dir
BASE_DIR=$(pwd)
DATA_DIR="${BASE_DIR}/data"
DOG_DATA_DIR="${DATA_DIR}/dog_reference"
RAW_DIR="${DATA_DIR}/raw"

mkdir -p ${DOG_DATA_DIR} ${RAW_DIR} 

# Get all raw fastq data from "Run" column via fasterq-dump
for ACC_NUM in $(tail -n +2 data/SraRunTable.csv | cut -d "," -f 1); do
    fasterq-dump ${ACC_NUM} \
    -O ${RAW_DIR} \
    --split-files
done

echo "All raw data downloaded."

# Download Canis familiaris referene genome via datasets
datasets download genome taxon "canis familiaris" --reference --filename ${DOG_DATA_DIR}/dog_reference_genome.zip

# Unzip to the correct dir
unzip -n ${DOG_DATA_DIR}/dog_reference_genome.zip -d ${DOG_DATA_DIR}

# Clean up the files it made 
rm ${DOG_DATA_DIR}/md5sum.txt ${DOG_DATA_DIR}/README.md ${DOG_DATA_DIR}/dog_reference_genome.zip

# Rename and move the reference genome
mv ${DOG_DATA_DIR}/ncbi_dataset/data/GCF_011100685.1/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fna ${DOG_DATA_DIR}/dog_reference_genome.fna

# Delete the remainder of the ncbi data dir 
rm -rf ${DOG_DATA_DIR}/ncbi_dataset

# Deactivate conda env
conda deactivate
# ------------------------------------------------------------

# Give executable permission
chmod +x scripts/01_download_data.sh

```

### Task 3. Clean up raw reads
```bash
# Script to clean reads
nano scripts/02_clean_reads.sh

# Add the following lines to 02_clean_reads.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------
#!/bin/bash
set -ueo pipefail

# Enter conda env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate vk-ncbi-env

# Set up absolute path directories from A7 dir
BASE_DIR=$(pwd)
DATA_DIR="${BASE_DIR}/data"

DOG_DATA_DIR="${DATA_DIR}/dog_reference"
RAW_DIR="${DATA_DIR}/raw"
CLEAN_DIR="${DATA_DIR}/clean"

mkdir -p ${CLEAN_DIR}  

# Loop through pairs of raw reads, use fastp to clean
for FWD_IN in ${RAW_DIR}/*_1.fastq; do

    # Var for the reverse input file by replacing 1 with 2 (fwd to rev)
    REV_IN="${FWD_IN/_1.fastq/_2.fastq}"

    # Make a temp var for the fwd and rev output file by adding the trimmed indicator to the filenames from input
    FWD_OUT="${FWD_IN/\/raw\//\/clean\/}"
    REV_OUT="${REV_IN/\/raw\//\/clean\/}"

    # Run fastp command, leaving trimming, n_base_limit, length_reqired as default
    fastp \
    --in1 ${FWD_IN} \
    --in2 ${REV_IN} \
    --out1 ${FWD_OUT} \
    --out2 ${REV_OUT} \
    --json /dev/null \
    --html /dev/null  \
    --average_qual 20
done

# Deactivate conda env
conda deactivate
# ------------------------------------------------------------

# Give executable permission
chmod +x scripts/02_clean_reads.sh

```

### Task 4. Map clean reads to dog genome
```bash
# Add bbmap to conda env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate vk-ncbi-env
conda install -y bbmap -c bioconda

# Export to config, deactivate
conda env export --no-builds > vk-ncbi-env.yml
conda deactivate 

# Script to map clean reads
nano scripts/03_map_reads.sh

# Add the following lines to 03_map_reads.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------
#!/bin/bash
set -ueo pipefail

# Enter conda env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate vk-ncbi-env

# Set up absolute path directories from A7 dir
BASE_DIR=$(pwd)
DATA_DIR="${BASE_DIR}/data"
OUT_DIR="${BASE_DIR}/output"

DOG_DATA_DIR="${DATA_DIR}/dog_reference"
RAW_DIR="${DATA_DIR}/raw"
CLEAN_DIR="${DATA_DIR}/clean"

mkdir -p ${OUT_DIR}  

DOG_GENOME="${DOG_DATA_DIR}/dog_reference_genome.fna"

# Loop through the clean reads
for FWD_IN in ${CLEAN_DIR}/*_1.fastq; do
    # Var for reverse input file (fwd to rev)
    REV_IN="${FWD_IN/_1.fastq/_2.fastq}"

    # Get the base name for that sample
    SAMPLE=$(basename ${FWD_IN} _1.fastq)

    # Where alignment results will be saved for full sample 
    FULL_SAM="${OUT_DIR}/${SAMPLE}.sam"

    # Run bbmap to map
    bbmap.sh \
        ref=${DOG_GENOME} \
        in1=${FWD_IN} \
        in2=${REV_IN} \
        out=${FULL_SAM} \
        minid=0.95 \
        -Xmx16g

done

rm -rf ${BASE_DIR}/ref

# Deactivate conda env
conda deactivate
# ------------------------------------------------------------

# Give executable permission
chmod +x scripts/03_map_reads.sh # Not going to run it now
```

### Task 5. Extract reads that matched dog genome
```bash
# Add samtools to conda env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate vk-ncbi-env
conda install samtools -c bioconda

# Export to config, deactivate
conda env export --no-builds > vk-ncbi-env.yml
conda deactivate 

nano scripts/03_map_reads.sh

# Add the following lines to 03_map_reads.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------
#!/bin/bash
set -ueo pipefail

# Enter conda env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate vk-ncbi-env

# Set up absolute path directories from A7 dir
BASE_DIR=$(pwd)
DATA_DIR="${BASE_DIR}/data"
OUT_DIR="${BASE_DIR}/output"

DOG_DATA_DIR="${DATA_DIR}/dog_reference"
RAW_DIR="${DATA_DIR}/raw"
CLEAN_DIR="${DATA_DIR}/clean"
# CLEAN_DIR="${BASE_DIR}/data/small_clean"

mkdir -p ${OUT_DIR}  

DOG_GENOME="${DOG_DATA_DIR}/dog_reference_genome.fna"

# Loop through the clean reads
for FWD_IN in ${CLEAN_DIR}/*_1.fastq; do
    # Var for reverse input file (fwd to rev)
    REV_IN="${FWD_IN/_1.fastq/_2.fastq}"

    # Get the base name for that sample
    SAMPLE=$(basename ${FWD_IN} _1.fastq)

    # Where alignment results will be saved for full sample 
    FULL_SAM="${OUT_DIR}/${SAMPLE}.sam"

    # Where alignment results will be saved for those reads mapped to dog genome 
    MATCH_SAM="${OUT_DIR}/${SAMPLE}_dog-matches.sam"

    # Run bbmap to map
    bbmap.sh \
        ref=${DOG_GENOME} \
        in1=${FWD_IN} \
        in2=${REV_IN} \
        out=${FULL_SAM} \
        minid=0.95 \
        -Xmx28g
    
    samtools view -S -F 4 ${FULL_SAM} > ${MATCH_SAM} 
    
done

rm -rf ${BASE_DIR}/ref

# Deactivate conda env
conda deactivate
# ------------------------------------------------------------

```

### Task 6. Submit your job to SLURM
```bash
# Ran scripts 1/2 individually on login node on just the first paired reading (small batch)
# Made a slurm version of script 3 to run on the same small batch 

nano assignment_07_pipeline.slurm

# Add the following lines to assignment_07_pipeline.slurm, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------
#!/bin/bash
#SBATCH --job-name=assignment_07
#SBATCH --nodes=1 # how many physical machines in the cluster
#SBATCH --ntasks=1 # how many separate 'tasks' (stick to 1)
#SBATCH --cpus-per-task=8 # how many cores (bora max is 20)
#SBATCH --time=8:00:00 # d-hh:mm:ss or just No. of minutes
#SBATCH --mem=32G # how much physical memory (all by default)
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
# ------------------------------------------------------------
# Give executable permission
chmod +x assignment_07_pipeline.slurm 

# Run and pray.
sbatch assignment_07_pipeline.slurm

# Is my script running?
sacct
```

### Task 7. Inspect your stdout and stderr
```bash
# Oscillating between these commands as we went on 
tail -n 30 output/assignment_07.out
tail -n 30 output/assignment_07.err
```

### Task 8. Inspect your results
```bash
grep -c "^@SRR" data/clean/*_1.fastq

```

### Task 9. Document Everything in README.md

# Pipeline Documentation: Automated Metagenomic Data Extraction and Mapping Against Reference

### Overview
This project provides a fully automated Slurm-based pipeline for processing human skin metagenomic sequencing data, checking for cross-species alignment. It is designed to download raw FASTQ data from the NCBI Sequence Read Archive (SRA) representing the human skin virome metagenomic data, perform quality control, and quantify sequences that map to the Canis familiaris (Dog) reference genome. 

This comparison may identify environmental canine DNA contamination within human skin microbial community metagenomic samle.

### Directory Structure
* `./scripts/`: Contains the functional worker scripts
    - `01_download_data.sh`: Acquires raw human skin virome FASTQ data using fasterq-dump and fetches the canine reference genome
    - `02_clean_reads.sh`: Uses `fastp` for adapter trimming and quality filtering to ensure mapping accuracy
    - `03_map_reads.sh`: Uses `bbmap` to align the human-derived virome reads against the dog reference genome, and `samtools` to extract reads that matched dog genome

* `./data/`: Organized storage for genomic data
     * `raw/`: Temporary storage for original SRA downloads from human skin studies
     * `clean/`: Output directory for processed, high-quality reads 
     * `dog_reference/`: Contains the indexed *Canis familiaris* genome used as the mapping target
     * `SraRunTable.csv`: Metadata file containing the SRA Accession IDs for the human skin samples

* `./output/`: Storage destination for results
    * Contains `*_dog-matches.sam` files (Human reads that successfully mapped to the Dog genome)
    * Stores the `.out` and `.err` logs for pipeline auditing and resource monitoring

* `assignment_07_pipeline.slurm`: The master script that manages environment setup, data gathering, and loops through the sample metadata

* `vk-ncbi-env.yml`: Exported Conda environment file documenting the specific versions of bioinformatics tools used

### How To Run the Pipeline
To execute the complete workflow on the W&M HPC, ensure you are in the assignment_07/ directory and submit the master assignment_07 pipeline to Slurm:

```bash
sbatch assignment_07_pipeline.slurm
```

### What the Ultimate Pipeline Script Does

The `assignment_07_pipeline.slurm` script automates the following stages sequentially, using a pre-built conda env for which the configuration is provided as `vk-ncbi-env.yml`:

1. **Environment Initialization:** The script initializes the shell and activates the project-level `vk-ncbi-env`. This ensures that `fasterq-dump`, `fastp`, and `bbmap` are available in the `$PATH`.
2. **Data Acquisition:** It calls `01_download_data.sh` to fetch human skin virome datasets from the NCBI Sequence Read Archive. Then, it retrieves the *Canis familiaris* (Dog) reference genome and prepares it for alignment.
3. **Quality Control:** The script passes the raw human-derived reads to `02_clean_reads.sh`. Using `fastp`, it trims low-quality bases.
4. **Cross-Species Mapping:** Using `bbmap` and `samtools` via `03_map_reads.sh`, the pipeline performs an alignment of the human skin virome sequences against the canine reference genome. 
5. **Cleanup:** The script automatically deletes the produced `ref` folder leaving only the filtered results.
6. **Logging:** All standard output and errors are redirected to the `output/` directory, providing a record of the mapping percentages and tool log for every sample in the `SraRunTable.csv`.

## Reflection:
My primary challenge was understanding the intent of the assignment as a whole (from the bioinformatics angle) and the purpose of each stage in the metagenomic workflow. Initially, I didn't get why I was mapping a human skin virome dataset against a canine reference genome or what the resulting output files were meant to represent. This made it difficult to troubleshoot the configuration of tools like fastp and bbmap. I also faced several technical failures where the pipeline crashed due incorrect memory or time allocations, and I adjusged my SLURM headers to adapt. 

Through this process, I improved my ability to use SLURM for resource allocation and monitoring. By following the .out and .err log files as the job ran, I was able to catch errors immediately rather than waiting for the entire process to finish. This assignment reinforced the benefits of a modular coding strategy, as splitting the workflow into separate scripts for downloading, cleaning, and mapping allowed me to isolate failures without restarting the entire pipeline. I had also never integrated the SLURM workflow with a conda environment that I had built for a project, adding another layer of depth.

### Task 10. Push to GitHub
```bash
git add -A
git commit -m "A7 README update"
git push
```