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

```

### Task 4. Run your install_gh.sh script
```bash
# Run the script
bash install_gh.sh

```

### Task 5. Add the location of the gh binary to your $PATH
```bash
# Add to PATH temporarily
export PATH=$PATH:$HOME/programs/gh_2.74.2_linux_amd64/bin
gh --version
# Output: gh version 2.74.2 (2025-06-18)
# Output: https://github.com/cli/cli/releases/tag/v2.74.2

# Add to .bashrc for permanent use
cd 
nano .bashrc

# Add these lines to the end of .bashrc, then read out (ctrl+o), enter, exit (ctrl+x)
# Assignment 4 Task 5 adding gh alias 2/20/26
export PATH=$PATH:$HOME/programs/gh_2.74.2_linux_amd64/bin

exec bash

# I also closed and reopened bora, start from home dir
cd 
```

### Task 6. Run gh auth login to setup your GitHub username and password
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

### Task 7. Create another installation script (for seqtk)
```bash
# Get back into programs directory
cd 
cd programs


```

### Task 8. Figure out seqtk
```bash

```

### Task 9. Write a `summarize_fasta.sh` script
```bash

```

### Task 10. Run `summarize_fasta.sh` in a loop on multiple files.
```bash

```

### Task 11: Document Everything in README.md
Reflection:

### Task 12. Push to GitHub
