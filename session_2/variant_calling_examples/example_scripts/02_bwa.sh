#!/bin/bash

set -euo pipefail # Exit on error, undefined variable, or error in a pipeline

SAMPLE="SRR7890883"
IN_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/results/01_fastp"
OUT_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/results/02_bwa"
REF_DIR="/workspaces/Introduction_to_Scientific_Computing/example_data/ref"
LOG_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/logs/02_bwa"

mkdir -p "${OUT_DIR}"
mkdir -p "${LOG_DIR}"

LIBRARY="lib1"
PLATFORM="ILLUMINA"
FASTP_R1="${IN_DIR}/${SAMPLE}.chr17_50k_R1_trimmed.fastq.gz"
FASTP_R2="${IN_DIR}/${SAMPLE}.chr17_50k_R2_trimmed.fastq.gz"
OUT_BAM="${OUT_DIR}/${SAMPLE}.chr17_50k.bam"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta.gz"
LOG="${LOG_DIR}/${SAMPLE}.bwa.log"
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
    --reference "${REF}" \
    -o "${OUT_BAM}" \
    -

echo "Indexing aligned reads"
samtools index \
    "${OUT_BAM}"
 
 echo "All done."
 
