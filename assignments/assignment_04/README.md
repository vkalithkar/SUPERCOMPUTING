# Assignment 4: Bash scripts and program PATHs

**Vandana Kalithkar**  
02/20/2026  

## Command Log
### Task 1. Make a special directory in your $HOME called "programs" (if you don't already have it)

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

# Back to home dir
cd

# Check to see if "programs" directory exists, it does exist so I don't need to create it
ls
cd programs

```

### Task 2. Download and unpack the gh "tarball" file
```bash

# Download the file
wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz

# Unzip the gzipped tarbell
tar -xzvf gh_2.74.2_linux_amd64.tar.gz

# Remove the old unzipped tarbell file (cleaning up)
rm gh_2.74.2_linux_amd64.tar.gz

```

### Task 3. Build a bash script from task 2
```bash
nano install_gh.sh

# Add the following lines to the install_gh.sh file, then read out (ctrl+o), enter, exit (ctrl+x)

#!/bin/bash
set -ueo pipefail

# Make sure that we're in the programs dir to install gh
cd "$HOME/programs"

# Download gh tarball
wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz

# Extract the tarball
tar -xzvf gh_2.74.2_linux_amd64.tar.gz

# Remove the tarball after extraction
rm gh_2.74.2_linux_amd64.tar.gz

echo "Install done!"

## Run the script
# bash install_gh.sh

```

### Task 4. Add the location of the gh binary to your $PATH
```bash
# Add to PATH temporarily
export PATH=$PATH:/sciclone/home/vkalithkar/programs/gh_2.74.2_linux_amd64/bin

gh --version
# Output: gh version 2.74.2 (2025-06-18)
# Output: https://github.com/cli/cli/releases/tag/v2.74.2

# Add to .bashrc for permanent use
cd 
nano .bashrc

# Add these lines to the end of .bashrc, then read out (ctrl+o), enter, exit (ctrl+x)
# Assignment 4 Task 5 adding gh alias 2/20/26
export PATH=$PATH:/sciclone/home/vkalithkar/programs/gh_2.74.2_linux_amd64/bin

exec bash

# I also closed and reopened bora, start from home dir
cd 
```

### Task 5. Run gh auth login to setup your GitHub username and password
```bash
gh auth login
# 1. Select: GitHub.com
# 2. Select: HTTPS
# 3. Select: Login with a web browser
# 4. Copy the 8-character one-time code
# 5. On your OWN machine's browser, go to github.com/login/device
# 6. Paste code and Authorize

# ctrl+C to exit the current program 

# To ensure it worked
gh auth status 
# Output confirms success

# Sync with git
cd SUPERCOMPUTING
git pull
```

### Task 6. Create another installation script (for seqtk)
```bash
# Get back into programs directory
cd 
cd programs

# Make the script
nano install_seqtk.sh

# Add the following lines to the install_seqtk.sh file, then read out (ctrl+o), enter, exit (ctrl+x)

#!/bin/bash
set -ueo pipefail

# Make sure that we're in the programs dir to install gh
cd "$HOME/programs"

# Download seqtk
git clone https://github.com/lh3/seqtk.git
cd seqtk
make

echo "Install done!"

# Add to PATH
echo "export PATH=$PATH:/sciclone/home/vkalithkar/programs/seqtk" >> ~/.bashrc

echo "Added to PATH!"

# Run the script
bash install_seqtk.sh

# Refresh bash environment
cd
source .bashrc
```

### Task 7. Figure out seqtk
```bash
# Into A3 folder to play with the data
cd SUPERCOMPUTING/assignments/assignment_03/data/

# Convert FASTQ to FASTA: (it's in their README)
seqtk seq -a GCF_000001735.4_TAIR10.1_genomic.fna > out.fa

#check to see if the change is correctly done 
ls # It is there!

# I just want to see what's there 
seqtk

# Size program looks promising 
seqtk size GCF_000001735.4_TAIR10.1_genomic.fna 

# Pipe that output into cut to isolate the num of seq and nucs
seqtk size GCF_000001735.4_TAIR10.1_genomic.fna | cut -f 1
seqtk size GCF_000001735.4_TAIR10.1_genomic.fna | cut -f 2

# Checking out comp command, outputs the table with sequence name and length I think 
seqtk comp GCF_000001735.4_TAIR10.1_genomic.fna
```

### Task 8. Write a `summarize_fasta.sh` script
```bash
# Get back into programs directory
cd 
cd programs

# Make the script
nano summarize_fasta.sh

# Add the following lines to the summarize_fasta.sh file, then read out (ctrl+o), enter, exit (ctrl+x)

#!/bin/bash
set -ueo pipefail

#Accepts the name of a fasta file as a positional argument ($1), Stores that filename in a variable
FILE=$1

#Total number of sequences
NUMSEQ=$(seqtk size $1 | cut -f 1)

#Total number of nucleotides
NUMBASE=$(seqtk size $1 | cut -f 2)

#Reports this information to stdout with explanations
echo "---------------------------------------"
echo "              FASTA Summary            "
echo "---------------------------------------"
echo "File processed: ${FILE}"
echo "Total number of sequences: ${NUMSEQ}"
echo "Total number of nucleotides: ${NUMBASE}"
echo ""
echo "Table of Sequence Names and Lengths:"

#A table of sequence names and lengths (all seqs in file)
SEQTAB=$(seqtk comp $1 | cut -f 1,2)
echo "${SEQTAB}"
echo "---------------------------------------"


# Execution ability
chmod +x summarize_fasta.sh

```

### Task 9. Run `summarize_fasta.sh` in a loop on multiple files.
```bash
# Add the A4 data to the .gitignore
cd
cd SUPERCOMPUTING
nano .gitignore

# Add the following lines to the bottom of the .gitignore file,then read out (ctrl+o), enter, exit (ctrl+x)

# Ignore data from assignment_04
assignments/assignment_04/data

# Into AA folder to grab some data
cd 
cd SUPERCOMPUTING/assignments/assignment_04
mkdir data

# Commit changes in preparation for acquiring FASTA files
cd 
cd SUPERCOMPUTING

git add -A # Only change was the .gitignore
git commit -m"modified .gitignore for A4 data"
git push


# File transfer done via GUI Filezilla from NIH-> Local, Local-> HPC
# genomes/all/GCF/000/005/005/GCF_000005005.1_B73_RefGen_v3/GCF_000005005.1_B73_RefGen_v3_cds_from_genomic.fna.gz
# genomes/all/GCF/000/005/115/GCF_000005115.1_dana_caf1/GCF_000005115.1_dana_caf1_rna_from_genomic.fna.gz    
# genomes/all/GCF/000/005/135/GCF_000005135.1_dere_caf1/GCF_000005135.1_dere_caf1_genomic.fna.gz
# genomes/all/annotation_releases/7222/102/GCF_000005155.2_dgri_caf1/GCF_000005155.2_dgri_caf1_genomic.fna.gz
# genomes/all/GCF/000/005/005/GCF_000005005.1_B73_RefGen_v3/GCF_000005005.1_B73_RefGen_v3_genomic.fna.gz

# Verified all file transfers with md5sum twice (one per transfer), caught some corrupted/incorrectly transfered files this way

# 03a429f3cfd05cbb988676df51b1c1c7 *GCF_000005115.1_dana_caf1_rna_from_genomic.fna.gz

# 89e8bbff3ffa32f0026ce85cad890352 *GCF_000005135.1_dere_caf1_genomic.fna.gz

# 1ec7fc598c54f60c6ebf1ba63db25664 *GCF_000005155.2_dgri_caf1_genomic.fna.gz

# d63a809916a69a31495390c3236ccd98 *GCF_000005005.1_B73_RefGen_v3_genomic.fna.gz

# Back to bora
cd 
cd SUPERCOMPUTING

# Sync with git
git pull

# Now onto testing
cd assignments/assignment_04/data
for file in *.gz; do summarize_fasta.sh $file;done

```

### Task 10. Document Everything in README.md
Reflection:
The primary challenge of this assignment was the "figure it out" requirement for the seqtk tool. I had to explore the program's internal help menus to identify the correct commands and sub-commands, such as 'size' and 'comp', to extract the required data. Another major hurdle was managing the $PATH environment variable. I had to debug my .bashrc file multiple times. Additionally, I had previously done all of the work for this class on campus, rather than in my home off-campus, so for several minutes, I did not understand why I was unable to connect to the bora cluster. I eventually remembered the Global Protect VPN and implemented it. 

Through this process, I practiced and gained several technical skills, such as practicing command substitution with the $(command) syntax to capture tool output into Bash variables within my scripts. I also learned the difference between downloading a pre-compiled program and compiling source code from scratch using the 'make' command. Finally, I had to learn to use the "cut" command to grab specific parts of data output. 

The $PATH is an environmental variable containing a list of directories where the system looks for executable files. When a command is typed, the system searches these directories in order until it finds a match. By adding my programs directory to the $PATH in my .bashrc, I ensured I could run my own scripts and installed tools from any location on the HPC without providing the full absolute path every time.

### Task 11: Push to GitHub
```bash
cd 
cd SUPERCOMPUTING
git status # working tree clean
```