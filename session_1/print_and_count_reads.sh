#!/bin/bash

FASTQ_FILE="../example_data/fastq/SRR7890883.chr17_50k_R1.fastq"  

echo "First ten lines of the fastq file:"  
cat "$FASTQ_FILE" | head -n 10  

echo "Counting the number of reads in the fastq file:"  
cat "$FASTQ_FILE" | wc -l | awk '{print $1/4}'
