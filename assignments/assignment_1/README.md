# Assignment 1 – Mock Project Setup

This README documents the exact sequence of commands used to create the
Assignment 1 project structure.  
All commands can be run line-by-line in a Unix shell to reproduce the directory
layout and placeholder files.

---

## Command Log

```bash

# Start at SUPERCOMPUTER folder, I was already in the directory containing SUPERCOMPUTING
cd ~/SUPERCOMPUTING

# Sync with git
git pull 

# Create assignment directory
mkdir assignments
cd assignments

# Create directory for first assignment
mkdir assignment_1
cd assignment_1

# Create README file for this command log Task 2
touch README.md

# Create the main markdown essay for Task 3
touch assignment_1_essay.md

# Create the rest of the directory examples to mimic the example
mkdir data scripts results docs config logs

# Verify that the project structure so far looks accurate
ls -R

# Create placeholder doc and log file
touch logs/logfile.log docs/example.txt

# Create placeholder data table
touch data/my_data.csv

# Create placeholder script file
touch scripts/script.sh

# Verify that the project structure so far looks accurate, need to add a config and results placeholder
ls -R

# Create config and results directory placeholder file
touch config/assignment_1.yaml results/blank_results.out


# Return to SUPERCOMPUTING directory, 2 parent directories up
cd ..
cd ..

# Add all changes, commit, and push to git repo 
git add -A
git commit -m "Assignment 1 mock project setup"
git push








