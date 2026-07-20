#!/bin/bash

echo "First ten lines of the fastq file:"
zcat sample.fastq.gz | head -n 10

echo "Counting the number of reads in the fastq file:"
zcat sample.fastq.gz | wc -l | awk '{print $1/4}'