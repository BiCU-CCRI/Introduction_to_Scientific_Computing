#!/bin/bash

set -euo pipefail # Exit on error, undefined variable, or error in a pipeline

# ###########################################################################################################################################################
# Edit these variables before running the script
#############################################################################################################################################################
SAMPLE="SRR7890883"
IN_DIR="/path/to/results/01_fastp"
OUT_DIR="/path/to/results/02_bwa"
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"
LOG="path/to/logs/bwa_${SAMPLE}.log"
#############################################################################################################################################################

mkdir -p "${OUT_DIR}"

LIBRARY="lib1"
PLATFORM="ILLUMINA"
FASTP_R1="${IN_DIR}/${SAMPLE}.chr17_50k_R1_trimmed.fastq"
FASTP_R2="${IN_DIR}/${SAMPLE}.chr17_50k_R2_trimmed.fastq"
OUT_CRAM="${OUT_DIR}/${SAMPLE}.chr17_50k.cram"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"

READ_GROUP="@RG\tID:${SAMPLE}.${LIBRARY}\tSM:${SAMPLE}\tLB:${LIBRARY}\tPL:${PLATFORM}\tPU:${SAMPLE}.${LIBRARY}"

echo "Aligning ${SAMPLE} to reference genome"
bwa mem \
    -t 1 \
    -M \
    -R "${READ_GROUP}" \
    "${REF}" \
    "${FASTP_R1}" \
    "${FASTP_R2}" \
    2> "${LOG}" |
samtools sort \
    -O CRAM \
    --reference "${REF}" \
    -o "${OUT_CRAM}" \
    -

echo "Indexing aligned reads"
samtools index \
    "${OUT_CRAM}"