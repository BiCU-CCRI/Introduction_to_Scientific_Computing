#!/bin/bash
#SBATCH --job-name=bwa
#SBATCH --output=logs/slurm_logs/02_bwa_%j.out
#SBATCH --error=logs/slurm_logs/02_bwa_%j.err
#SBATCH --time=00:05:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=3G
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq

set -euo pipefail

module load BWA/0.7.17-GCCcore-11.3.0
module load SAMtools/1.18-GCC-12.3.0

SAMPLE="SRR7890883"
IN_DIR="results/01_fastp"
OUT_DIR="results/02_bwa"
LOG_DIR="logs/02_bwa"
REF_DIR="../../example_data/ref"

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
