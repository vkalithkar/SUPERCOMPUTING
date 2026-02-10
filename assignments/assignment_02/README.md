## Command Log

### Task 1

```bash
#------------------------- Starting LOCALLY  --------------------------

# Start at SUPERCOMPUTER folder, I was already in the directory containing SUPERCOMPUTING
cd ~/SUPERCOMPUTING

# Sync with git
git pull

# Log onto HPC with SSH
bora
# Enter password

#------------------------------ Via BORA  -----------------------------

# Within Bora, enter our directory
cd SUPERCOMPUTING/

# Sync with git
git pull

# Enter assignment directory
cd assignments/assignment_02/

# Check if data folder exists
ls

# It doesn't exist, create directory
mkdir data

# Check assignment_02 directory
ls -A

# Return to SUPERCOMPUTING directory
cd ..
cd ..

# Add assignment_02 data folder to .gitignore
nano .gitignore
# Add this line to the .gitignore, save, exit
assignments/assignment_02/data

# Push changes to git
git add -A
git commit -m "modified .gitignore to ignore A2 data"
git push

# Exit from Bora
exit

#------------------------- Now LOCALLY  --------------------------
# Sync with git
git pull

# The following did not work

# # Log into FTP for NCBI
# ftp ftp.ncbi.nlm.nih.gov

# # use "anonymous" as user and email address as password

# #------------------------- Now FTP  --------------------------

# # Navigate to the desired directory
# cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2

# # try to get the files

# get GCF_000005845.2_ASM584v2_genomic.fna.gz 

# bye

``` 

### Task 2

------------------------- GUI FTP  --------------------------

- Opened Filezilla, connected to  ftp.ncbi.nlm.nih.gov server (anonymous as user, wm email as pass)
- Navigated to genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2 directory
- Found the 2 desired files: GCF_000005845.2_ASM584v2_genomic.gff.gz and GCF_000005845.2_ASM584v2_genomic.fna.gz
- Dragged the files over to ~/SUPERCOMPUTING/assignments/assignment_02/data 


### Task 3
```bash
#------------------------- Now LOCALLY  --------------------------
# Verify data is present in assignment_02/data 
ls

# Command-line sftp with HPC
sftp vkalithkar@bora.sciclone.wm.edu
# Enter password

# Send files to HPC server
put GCF_000005845.2_ASM584v2_genomic.gff.gz
put GCF_000005845.2_ASM584v2_genomic.fna.gz

# Exit
bye

bora
# Enter password

# ------------------------- VIA BORA --------------------------
# Move the newly added data files into the SUPERCOMPUTING/assignments/assignment_02/data directory
mv GCF_000005845.2_ASM584v2_genomic.fna.gz SUPERCOMPUTING/assignments/assignment_02/data
mv GCF_000005845.2_ASM584v2_genomic.gff.gz SUPERCOMPUTING/assignments/assignment_02/data

# Git pull to sync changes
cd SUPERCOMPUTING
git pull

# Ensure moved files are present in the directory
cd assignments/assignment_02/data
ls -l

# Permissions read as such:
# -rw-------. 1 vkalithkar apscu 1379902 Feb 10 11:57 GCF_000005845.2_ASM584v2_genomic.fna.gz
# -rw-------. 1 vkalithkar apscu  406858 Feb 10 11:57 GCF_000005845.2_ASM584v2_genomic.gff.gz

# Permissions are too restrictive, only owners have read/write
# Use chmod to give group the read permissions
chmod g+r GCF_000005845.2_ASM584v2_genomic.fna.gz
chmod g+r GCF_000005845.2_ASM584v2_genomic.gff.gz
ls -l

# Still too restricitve, giving others read permissions
chmod a+r GCF_000005845.2_ASM584v2_genomic.gff.gz
chmod a+r GCF_000005845.2_ASM584v2_genomic.fna.gz
ls -l

exit
#------------------------- Now LOCALLY  --------------------------
```
### Task 4

```bash

# Check hashes of the 2 data files that we pulled from NCBI
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
# Output
# c13d459b5caa702ff7e1f26fe44b8ad7 *GCF_000005845.2_ASM584v2_genomic.fna.gz

md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
# Output
# 2238238dd39e11329547d26ab138be41 *GCF_000005845.2_ASM584v2_genomic.gff.gz

bora
# Enter password

# ------------------------- VIA BORA --------------------------
# Git pull to sync changes
cd SUPERCOMPUTING
git pull

# Enter assignment directory where data lies
cd assignments/assignment_02/data
ll


# Check hashes of the 2 data files that we transferred from local machine
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
# Output
# c13d459b5caa702ff7e1f26fe44b8ad7  GCF_000005845.2_ASM584v2_genomic.fna.gz

md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
# Output
# 2238238dd39e11329547d26ab138be41  GCF_000005845.2_ASM584v2_genomic.gff.gz

# The hashes directly match 1-1, file integrity is intact
```

### Task 5
```bash
# Return back to home directory /sciclone/home/vkalithkar
cd

# Check to see if .bashrc file is present
ls -a

nano .bashrc

# Add the following lines
# # Assignment 2 Task 5 Useful Bash Aliases 2/10/26
# alias u='cd ..;clear;pwd;ls -alFh --group-directories-first'
# alias d='cd -;clear;pwd;ls -alFh --group-directories-first'
# alias ll='ls -alFh --group-directories-first'

# Verify that the reading out worked when nano editing
cat .bashrc

# Run the .bashrc to enable the aliases
source ~/.bashrc

exit
```

#### Description of Useful Aliases:
- u: changes dir to parent, clears, prints new current working dir, listing all files (including hidden) in human-readable long format
- d: changes dir to the previous dir, clears, prints new current working dir, listing all files (including hidden) in human-readable long format
- ll: lists all files in current dir (including hidden) in human-readable long format
