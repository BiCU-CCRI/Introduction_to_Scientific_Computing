#!/bin/bash
#SBATCH --job-name=mark_dup
#SBATCH --output=logs/slurm_logs/03_markdup_%j.out
#SBATCH --error=logs/slurm_logs/03_markdup_%j.err
#SBATCH --time=00:05:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=6G
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq

set -euo pipefail

module load GATK/4.1.8.1-GCCcore-9.3.0-Java-1.8

SAMPLE="SRR7890883"
IN_DIR="results/02_bwa"
OUT_DIR="results/03_markdup"
LOG_DIR="logs/03_markdup"
REF_DIR="../../example_data/ref"

mkdir -p "${OUT_DIR}"
mkdir -p "${LOG_DIR}"

IN_BAM="${IN_DIR}/${SAMPLE}.chr17_50k.bam"
OUT_BAM="${OUT_DIR}/${SAMPLE}.chr17_50k.markdup.bam"
METRICS="${OUT_DIR}/${SAMPLE}.markdup.metrics.txt"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta.gz"
LOG="${LOG_DIR}/${SAMPLE}.markdup.log"

echo "Marking duplicate reads for sample ${SAMPLE}"
gatk --java-options "-Xmx5g" MarkDuplicates \
    --INPUT "${IN_BAM}" \
    --OUTPUT "${OUT_BAM}" \
    --METRICS_FILE "${METRICS}" \
    --REFERENCE_SEQUENCE "${REF}" \
    --CREATE_INDEX true \
    --VALIDATION_STRINGENCY SILENT \
    --OPTICAL_DUPLICATE_PIXEL_DISTANCE 2500 \
    > "${LOG}" 2>&1
