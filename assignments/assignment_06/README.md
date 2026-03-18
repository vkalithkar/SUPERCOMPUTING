# Assignment 6: Software and environments

**Vandana Kalithkar**  
03/17/2026  

## Command Log
### Task 1. Setup assignment_6/ directory

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
# Ignore data from assignment_06
assignments/assignment_06/data
assignments/assignment_06/assemblies
# ------------------------------------------------------------

# Set up assignment_06 dir
cd assignments/assignment_06
mkdir assemblies data scripts

# assemblies has 3 subdirectories
cd assemblies/
mkdir assembly_conda assembly_local assembly_module

# Return to A6 directory
cd ..
```

### Task 2. Download raw ONT data

```bash
# Making the download data script in scripts directory
cd scripts
nano 01_download_data.sh

# Add the following lines to 01_download_data.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------

#!/bin/bash
set -ueo pipefail

# Move into the directory where the data needs to be installed (Only make the data dir if it's not already there)
mkdir -p ./data/
cd ./data/

# Download the data
wget -O SRR33939694.fastq.gz "https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1"

# Unzip the data
gunzip SRR33939694.fastq.gz

# ------------------------------------------------------------

# Make this script executable
chmod +x 01_download_data.sh

# Enter back into A6 dir
cd ..

# Run script
./scripts/01_download_data.sh
```

### Task 3. Get Flye v2.9.6 (local build)

```bash
# Create the Flye local build script
nano scripts/02_flye_2.9.6_manual_build.sh

# Add the following lines to 02_flye_2.9.6_manual_build.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------

#!/bin/bash
set -ueo pipefail

# Clone to programs dir
cd ~/programs

# Clone it
git clone https://github.com/fenderglass/Flye
cd Flye
make

# ------------------------------------------------------------
chmod +x scripts/02_flye_2.9.6_manual_build.sh

# Run Flye download script
./scripts/02_flye_2.9.6_manual_build.sh

# Check to see if it worked
cd ~/programs/ # I see the Flye folder there

# Return to A6 dir
cd
cd SUPERCOMPUTING/assignments/assignment_06

# Add Flye location to PATH 
echo "export PATH=$PATH:${HOME}/programs/Flye/bin" >> ~/.bashrc
source ~/.bashrc

# Check to see flye runs from A6 dir
flye --help # I see the documentation, it works
```

### Task 4. Get Flye v2.9.6 (conda build)

```bash
# Create the Flye local build script
nano scripts/02_flye_2.9.6_conda_install.sh

# Add the following lines to 02_flye_2.9.6_conda_install.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------

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

# ------------------------------------------------------------
# Provide executable permission
chmod +x scripts/02_flye_2.9.6_conda_install.sh

# Run the script
bash scripts/02_flye_2.9.6_conda_install.sh

# Reactivate env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate flye-env

# Test to see if it works: Returns 2.9.6-b1802
flye -v

# Deactivate env
conda deactivate

# See if yaml file exists in A6 dir, it does
ll
```

### Task 5. Decipher how to use Flye

```bash

# Assemble a command, run it
flye --nano-hq data/SRR33939694.fastq \
     --genome-size 150k \
     --out-dir assemblies/assembly_conda \
     --threads 4

# Ensure that all the output files are where they're supposed to be
ls -R

```

### Task 6. Run Flye, 3 ways

#### Task 6A. Write a script to run Flye using conda

```bash
nano scripts/03_run_flye_conda.sh 

# Add the following lines to scripts/03_run_flye_conda.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------

#!/bin/bash
set -ueo pipefail

# Set up env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate flye-env

# Set up absolute path directories
BASE_DIR=$(pwd)
OUT_DIR="${BASE_DIR}/assemblies/assembly_conda"
DATA_DIR="${BASE_DIR}/data"

# Create the output dir in case it doesn't exist
mkdir -p ${OUT_DIR}

# Run the flye command
flye --nano-hq ${DATA_DIR}/SRR33939694.fastq \
     --genome-size 150k \
     --out-dir ${OUT_DIR} \
     --threads 4

# Clean up the output bloat
rm -rf ${OUT_DIR}/00-assembly/ ${OUT_DIR}/10-consensus/ ${OUT_DIR}/20-repeat/ ${OUT_DIR}/30-contigger/ ${OUT_DIR}/40-polishing/
rm ${OUT_DIR}/assembly_graph* ${OUT_DIR}/assembly_info.txt ${OUT_DIR}/params.json

# Rename the files
mv ${OUT_DIR}/assembly.fasta ${OUT_DIR}/conda_assembly.fasta
mv ${OUT_DIR}/flye.log ${OUT_DIR}/conda_flye.log

# Deactivate this env
conda deactivate

# ------------------------------------------------------------

# Start fresh
rm -rf assemblies/assembly_conda/

# Give executable permissions
chmod +x scripts/03_run_flye_conda.sh

# Run the script
bash scripts/03_run_flye_conda.sh

# See if it worked
ls -R
```

#### 6B. Same as 6A, but using the module environment

```bash

# See what mdoules we have installed
module avail
# Flye/gcc-11.4.1/2.9.6     This is what I'm seeing

nano scripts/03_run_flye_module.sh 

# Add the following lines to scripts/03_run_flye_module.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------

#!/bin/bash
set -ueo pipefail

# Set up env with module
module load Flye/gcc-11.4.1/2.9.6

# Set up absolute path directories
BASE_DIR=$(pwd)
OUT_DIR="${BASE_DIR}/assemblies/assembly_module"
DATA_DIR="${BASE_DIR}/data"

# Create the output dir in case it doesn't exist
mkdir -p ${OUT_DIR}

# Run the flye command
flye --nano-hq ${DATA_DIR}/SRR33939694.fastq \
     --genome-size 150k \
     --out-dir ${OUT_DIR} \
     --threads 4

# Clean up the output bloat
rm -rf ${OUT_DIR}/00-assembly/ ${OUT_DIR}/10-consensus/ ${OUT_DIR}/20-repeat/ ${OUT_DIR}/30-contigger/ ${OUT_DIR}/40-polishing/
rm ${OUT_DIR}/assembly_graph* ${OUT_DIR}/assembly_info.txt ${OUT_DIR}/params.json

# Rename the files
mv ${OUT_DIR}/assembly.fasta ${OUT_DIR}/module_assembly.fasta
mv ${OUT_DIR}/flye.log ${OUT_DIR}/module_flye.log

# ------------------------------------------------------------

# Start fresh
rm -rf assemblies/assembly_module/

# Give executable permissions
chmod +x scripts/03_run_flye_module.sh

# Run the script
bash scripts/03_run_flye_module.sh

# See if it worked
ls -R
```

#### 6C. Same as 6A, but pointing flye to your local build

```bash
nano scripts/03_run_flye_local.sh 

# Add the following lines to scripts/03_run_flye_local.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------

#!/bin/bash
set -ueo pipefail

# Set up env by temporarily adding Flye from my programs to my PATH (redundant)
export PATH="$PATH:${HOME}/programs/Flye/bin"

# Set up absolute path directories
BASE_DIR=$(pwd)
OUT_DIR="${BASE_DIR}/assemblies/assembly_local"
DATA_DIR="${BASE_DIR}/data"

# Create the output dir in case it doesn't exist
mkdir -p ${OUT_DIR}

# Run the flye command
flye --nano-hq ${DATA_DIR}/SRR33939694.fastq \
     --genome-size 150k \
     --out-dir ${OUT_DIR} \
     --threads 4

# Clean up the output bloat
rm -rf ${OUT_DIR}/00-assembly/ ${OUT_DIR}/10-consensus/ ${OUT_DIR}/20-repeat/ ${OUT_DIR}/30-contigger/ ${OUT_DIR}/40-polishing/
rm ${OUT_DIR}/assembly_graph* ${OUT_DIR}/assembly_info.txt ${OUT_DIR}/params.json

# Rename the files
mv ${OUT_DIR}/assembly.fasta ${OUT_DIR}/local_assembly.fasta
mv ${OUT_DIR}/flye.log ${OUT_DIR}/local_flye.log

# ------------------------------------------------------------

# Start fresh
rm -rf assemblies/assembly_local/

# Give executable permissions
chmod +x scripts/03_run_flye_local.sh

# Run the script
bash scripts/03_run_flye_local.sh

# See if it worked
ls -R
```

### Task 7. Compare the results in the log files

```bash

# Get the last 10 lines of the conda, module, and local flye logs
cat assemblies/assembly_conda/conda_flye.log | tail -n 10

# Try to automate this with the find command for all 3 runs
tail -n 10 $(find assemblies/ -name "*.log") 
# The only change in the outputs is the time that it was run, otherwise the length, fragments, largest fragment, scaffolds, and mean coverage are the same         
     #    Total length:   44285
     #    Fragments:      1
     #    Fragments N50:  44285
     #    Largest frg:    44285
     #    Scaffolds:      0
     #    Mean coverage:  863

```

### Task 8. Build a `pipeline.sh` script

```bash

nano pipeline.sh

# Add the following lines to scripts/pipeline.sh, then read out (ctrl+o), enter, exit (ctrl+x)
# ------------------------------------------------------------

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

# ------------------------------------------------------------

# Permit execution
chmod +x pipeline.sh

```

### Task 9. Delete everything (except scripts) and start over

```bash
# I wanted to turn this into a script (the "delete" portions)

# Remove the folders
rm -rf assemblies data

# Remove the config file
rm flye-env.yml

# Remove the Flye local build
cd ~/programs
rm -rf Flye
cd 
cd SUPERCOMPUTING/assignments/assignment_06

# Remove the conda env to create again
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
mamba env remove -n flye-env -y 

# Run the big pipeline! 
bash pipeline.sh
```

### Task 10. Document Everything in README.md

# Pipeline Documentation: Automated Genome Assembly Comparison with Flye

### Overview
This project provides a fully automated Bash pipeline for genome assembly provided Oxford Nanopore Technologies (ONT) sequence data. This workflow evaluates the reproducibility of the Flye assembler tool across three installation methods: a manual build, a Conda environment, and a system-wide module on the W&M HPC.

### Directory Structure
* `./scripts/`: Contains the functional worker scripts
    - `01_download_data.sh`: Acquires and extracts raw ONT FASTQ data
    - `02_flye_2.9.6_manual_build.sh`: Clones and compiles Flye from source in the user's `~/programs/` directory
    - `02_flye_2.9.6_conda_install.sh`: Builds a dedicated Conda environment for using Flye
    - `03_run_flye_conda.sh`: Runs the assembly using the created Conda environment
    - `03_run_flye_local.sh`: Runs the assembly using the manually compiled local build
    - `03_run_flye_module.sh`: Runs the assembly using the HPC-provided software module
* `./data/`: Storage for the raw Nanopore sequencing reads (E. coli phages) that get downloaded in `01_download_data.sh`
* `./assemblies/`: Contains the final output for the final process, where each contains their respective `assembly.fasta` assembled genomes and `flye.log` log file for the run.
     * `assembly_conda`: Output from the Conda-based run
     * `assembly_local`: Output from the manual build run 
     * `assembly_module`: Output from the HPC module run
* `./pipeline.sh/`: The master orchestration script that runs all of the other scripts in sequence
* `./flye-env.yml/`: The exported environment file documenting all dependencies for the `flye-env` conda environment
* `./README.md/`: Documentation and reflection: explains setup, usage, and observations

### How To Run the Pipeline
To execute the complete genome assembly workflow from start to finish, ensure you are in the `assignment_06/` directory and run:

```bash
bash pipeline.sh
```
### What the Ultimate Pipeline Script Does

The `pipeline.sh` script executes the following stages sequentially:
1. **Data Acquisition:** Calls `01_download_data.sh` to fetch the ONT dataset into `./data/` and decompress it, cleaning up the extraneous zipped data file
2. **Local Compilation:** Calls `02_flye_2.9.6_manual_build.sh` to clone the Flye repository into `~/programs/` and compile the source code
3. **Environment Setup:** Calls `02_flye_2.9.6_conda_install.sh `to create the `flye-env` using Mamba and export the `flye-env.yml` configuration for use as a conda environment
4. **Assemblies:** Runs the assembly three separate times:
     * Uses the **Conda environment** to generate `conda_assembly.fasta`
     * Uses the W&M **HPC Module** to generate `module_assembly.fasta`
     * Uses the **Manual Build** in the PATH to generate `local_assembly.fasta`
5. Comparison: Finally, it prints the last 10 lines of each log file to the screen to verify that all three methods indeed produced identical assembly statistics.

## Reflection:
One of my primary challenges was finding that I couldn't run pipeline.sh without crashing due to existing files or environments from earlier tasks and builds. During Task 9, I initially struggled with conflicts where the manual Flye build or the Conda environment creation would error out if those directories or environments already existed from a previous run. I ultimately concluded that the cleanest approach was to handle the "cleanup" as a manual step within Task 9 by removing the assemblies/, data/, and programs/Flye directories along with the flye-env environment before execution. This emulated the clean start for the pipeline that a user should ideally implement it for. Furthermore, I initially started using absolute paths, but that would have broken a new user's run. I eventually transitioned to relative paths using BASE_DIR=$(pwd).

I significantly improved my understanding of shell environments and the organization required for such workflows. This assignment reinforced my preference for a modular coding strategy, as splitting the workflow into distinct scripts made debugging much easier by isolating failures to specific portions. I now have a much clearer grasp of the three primary software installation methods: HPC modules, Conda environments, and manual builds. While the module method is my preference due to its ability for quick implementation, it is dependent on the specific tool existing on the HPC. Otherwise, I prefer the local build approach  for its simplicity in single- or few-tool tasks, though I recognize that Conda is better for complex projects requiring multiple interdependent packages where version is important. Moving forward, I will check for a module first to save time, but I'll evaluate whether to use a local build or Conda, depending on the task itself and how many packages are needed.

### Task 11. Push to GitHub

```bash
git add -A
git commit -m "A6 README update"
git push
```