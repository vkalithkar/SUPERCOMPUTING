## Command Log

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

# Within Bora, enter assignment directory
cd SUPERCOMPUTING/assignments/assignment_02/

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

# Log into FTP for NCBI
ftp ftp.ncbi.nlm.nih.gov

# use "anonymous" as user and email address as password

#------------------------- Now FTP  --------------------------

# Navigate to the desired directory
cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2