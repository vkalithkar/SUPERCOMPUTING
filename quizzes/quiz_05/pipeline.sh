#!/bin/bash

# make a data directory with raw and clean data folder and an output folder, download the data as a zipped tarbell file from the URL, move the data into the raw data folder, and unzip it
bash scripts/01_prep_data.sh

# Use the seqkit tool stats command to take all the fastq files from the raw data we just unzipped, and processs it, storing the output in the output folder with the given name
bash scripts/02_get_stats.sh

# remove the old raw data zipped tarbell file folder
bash scripts/03_cleanup.sh

# dont need the bash but it doesnt hurt
