# Assignment 3: Exploring DNA sequence file with command line tools

**Vandana Kalithkar**  
02/18/2026  

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

# Add assignment_03 data folder to .gitignore
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

#1. How many sequences are in the FASTA file? (answer=7)
# Counts the number of times that ">" char begins a line, should be the number of sequences 
grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l
# output: 7

# 2. What is the total number of nucleotides (not including header lines or newlines)? (answer=119,668,634)
# Grab the lines where the line does NOT (-v) start with ">" in the file, pipe that into a transform function to delete (-d) newline chars, and then count chars from that via wc
grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna | tr -d "\n" | wc -c
# output: 119668634

# 3. How many total lines are in the file? (answer=14)
# Directly counts the number of lines
wc -l GCF_000001735.4_TAIR10.1_genomic.fna
# output: 14 GCF_000001735.4_TAIR10.1_genomic.fna

# 4. How many header lines contain the word "mitochondrion"? (answer=1)
# Count the number of time the specific string "mitochondrion" appears in the file, then pipe it into the wc function and count the number of lines
grep "mitochondrion" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l
# output: 1

# 5. How many header lines contain the word "chromosome"? (answer=5)
# Count the number of time the specific string "chromosome" appears in the file, then pipe it into the wc function and count the number of lines
grep "chromosome" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l
# output: 5

# 6. How many nucleotides are in each of the first 3 chromosome sequences? (answer=30,427,672   19,698,290  23,459,831)
# Grab all lines not starting with > (sequences) from this file, now just grab the first 3 lines, and enumerate the number of chars per each line with awk, but add one since awk doesn't count newline and the question seems to do that
grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna | head -n 3 | awk '{print length+1}'
# output: 30427672 19698290 23459831

# 7. How many nucleotides are in the sequence for 'chromosome 5'? (answer=26,975,503)
# The 10th line in the file is associated with the sequence for chromosome 5, so use the head/tail commands to grab that particular line and then use wc to find the number of chars
head -n 10 GCF_000001735.4_TAIR10.1_genomic.fna | tail -n 1 | wc -c
# output: 26975503

# 8. How many sequences contain "AAAAAAAAAAAAAAAA"? (answer=1)
# Count the number of time the specific string "AAAAAAAAAAAAAAAA" appears in the file, then pipe it into the wc function and count the number of lines
grep "AAAAAAAAAAAAAAAA" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l
# output: 1

# 9. If you were to sort the sequences alphabetically, which sequence (header) would be first in that list? (answer=>NC_000932.1...)
# I figured that some type of sort program existed, used the --help command to learn about it. I grabbed the sequence headers using the grep command I referenced in #1, put this command into a command sub. to make an imaginary file, sorted the file as per the sort --help said, and used head to grab the first line of that file output
sort <(grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna) | head -n 1
# output: NC_000932.1 Arabidopsis thaliana chloroplast, complete genome


# 10. How would you make a new tab-separated version of this file, where the first column is the headers and the second column are the associated sequences? (show the command(s))
# Use the paste program to paste the grep command from #1 (grab the headers only) with the grep from #2 (non-header lines, only seqs)
paste <(grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna) <(grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna)
# output: (too long to show)

```
### Task 5: Write a reflection in your README.md

My approach to solving the task and writing the longer commands was very similar to what I did to learn Java and Python programming. I came up with a general approach (a barebone idea to tackle the core issue of the program) and worked outward in a series of increasingly-complex commands. When things failed, I had a more readable and interpretable place to debug from. The hardest part about this, of course, was coming up with the approach. As I gain more practice with the Unix tools, I assume that I’ll become more familiar with the standard commands/techniques and broadly how they can be implemented. 

I’ve learned how to better identify the places where the commands can be useful (knowing to manipulate new-lines and reading out into dummy files if another program requires it as input). There are also small tips and tricks I’ve learned, like how the echo command adds a new line if I’ve programmatically gotten rid of all the new lines. As of now, I’m still becoming comfortable with the tools and being very creative in implementation. I still find that I get lost in understanding how the computer might take a command and interpret it, sort of like PEMDAS for order of operations. It then becomes difficult to formulate longer commands since a syntactic error can break it. 

I am also definitely having trouble with regular expressions. I have no foundational knowledge in crafting Regex (never learned it previously), so the grep commands are particularly difficult to me. The skills that I’m practicing in this assignment are universal to computational work: the ability to be creative while manipulating a set of programmatic tools to massage out an efficient, readable desired outcome. As I mentioned, I’m tackling this assignment like I’ve tackled all other programming assignments in my life, and hopefully this method universally improves my general “puzzle-solving” skills for computation, exercising the creative part of my brain.
