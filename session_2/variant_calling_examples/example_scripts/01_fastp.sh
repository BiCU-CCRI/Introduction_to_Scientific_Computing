#!/bin/bash

set -euo pipefail # Exit on error, undefined variable, or error in a pipeline

SAMPLE="SRR7890883"
IN_DIR="/workspaces/Introduction_to_Scientific_Computing/example_data/fastq"
OUT_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/results/01_fastp"
LOG_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/logs/01_fastp/"

mkdir -p "${OUT_DIR}"
mkdir -p "${LOG_DIR}"

RAW_R1="${IN_DIR}/${SAMPLE}.chr17_50k_R1.fastq"
RAW_R2="${IN_DIR}/${SAMPLE}.chr17_50k_R2.fastq"
TRIMMED_R1="${OUT_DIR}/${SAMPLE}.chr17_50k_R1_trimmed.fastq"
TRIMMED_R2="${OUT_DIR}/${SAMPLE}.chr17_50k_R2_trimmed.fastq"
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
    --json "${FASTP_JSON}" > "${LOG}" 2>&1