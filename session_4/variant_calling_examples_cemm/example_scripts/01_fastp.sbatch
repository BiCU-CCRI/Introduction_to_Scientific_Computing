#!/bin/bash
#SBATCH --job-name=fastp
#SBATCH --output=logs/slurm_logs/01_fastp_%j.out
#SBATCH --error=logs/slurm_logs/01_fastp_%j.err
#SBATCH --time=00:05:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=3G
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq

set -euo pipefail

module load fastp/0.23.2-GCC-11.3.0

SAMPLE="SRR7890883"
IN_DIR="../../example_data/fastq"
OUT_DIR="results/01_fastp"
LOG_DIR="logs/01_fastp/"

mkdir -p "${OUT_DIR}"
mkdir -p "${LOG_DIR}"

RAW_R1="${IN_DIR}/${SAMPLE}.chr17_50k_R1.fastq.gz"
RAW_R2="${IN_DIR}/${SAMPLE}.chr17_50k_R2.fastq.gz"
TRIMMED_R1="${OUT_DIR}/${SAMPLE}.chr17_50k_R1_trimmed.fastq.gz"
TRIMMED_R2="${OUT_DIR}/${SAMPLE}.chr17_50k_R2_trimmed.fastq.gz"
FASTP_HTML="${OUT_DIR}/${SAMPLE}.chr17_50k.html"
FASTP_JSON="${OUT_DIR}/${SAMPLE}.chr17_50k.json"
LOG="${LOG_DIR}/${SAMPLE}.fastp.log"

echo "Running fastp on ${SAMPLE}"
fastp \
    --in1 "${RAW_R1}" \
    --in2 "${RAW_R2}" \
    --out1 "${TRIMMED_R1}" \
    --out2 "${TRIMMED_R2}" \
    --detect_adapter_for_pe \
    --thread 1 \
    --html "${FASTP_HTML}" \
    --json "${FASTP_JSON}" \
    > "${LOG}" 2>&1

echo "All done."
