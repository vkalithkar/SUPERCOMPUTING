#!/bin/bash

# Pipeline script is the conductor. Calls modular scripts in order
# usage: ./pipeline.sh [N bases to drop]
# Set variable "N" to be the number of bases to chop

# set project directory where files are found
# this is mine, but you will have to change it to the correct location for your project
MAIN_DIR="/sciclone/home/gzahn/SUPERCOMPUTING/lessons/lesson_05"

# go to that location
cd $MAIN_DIR

# Chop up the data files
./scripts/chop_files.sh $1

# Run stats
./scripts/get_stats.sh
