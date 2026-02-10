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

'''

------------------------- GUI FTP  --------------------------

- Opened Filezilla, connected to  ftp.ncbi.nlm.nih.gov server
- Navigated to genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2 directory
- Found the 2 desired files: GCF_000005845.2_ASM584v2_genomic.gff.gz and GCF_000005845.2_ASM584v2_genomic.fna.gz
