#!/bin/bash

echo "First ten lines of the fastq file:"
cat ../example_data/fastq/SRR7890883.chr17_50k_R1.fastq | head -n 10

echo "Counting the number of reads in the fastq file:"
cat ../example_data/fastq/SRR7890883.chr17_50k_R1.fastq | wc -l | awk '{print $1/4}'