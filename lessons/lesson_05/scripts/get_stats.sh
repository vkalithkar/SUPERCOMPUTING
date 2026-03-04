#!/bin/bash
# Take files as input, Run seqkit stats on them all, export results
seqkit stats ${SHARED_DIR}/lesson_05/data/*.fastq > ./output/stats.tsv

