#!/bin/bash

#SBATCH --job-name=fastp
#SBATCH --output=fastp_%j.out
#SBATCH --error=fastp_%j.err
#SBATCH --time=00:05:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=3G
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq

set -euo pipefail # Exit on error, undefined variable, or error in a pipeline

# ###########################################################################################################################################################
# Edit these variables before running the script
#############################################################################################################################################################
SAMPLE="SRR7890883"
IN_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/fastq"
OUT_DIR="/path/to/results/01_fastp"
LOG="/path/to/logs/fastp_${SAMPLE}.log"
#############################################################################################################################################################

conda_env_name="somatic_variant_calling"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"

mkdir -p "${OUT_DIR}"

RAW_R1="${IN_DIR}/${SAMPLE}.chr17_50k_R1.fastq"
RAW_R2="${IN_DIR}/${SAMPLE}.chr17_50k_R2.fastq"
TRIMMED_R1="${OUT_DIR}/${SAMPLE}.chr17_50k_R1_trimmed.fastq"
TRIMMED_R2="${OUT_DIR}/${SAMPLE}.chr17_50k_R2_trimmed.fastq"
FASTP_HTML="${OUT_DIR}/${SAMPLE}.chr17_50k.html"
FASTP_JSON="${OUT_DIR}/${SAMPLE}.chr17_50k.json"

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