#!/bin/bash

#SBATCH --job-name=fastp
#SBATCH --output=/path/to/results_dir/01_fastp/fastp_%j.out
#SBATCH --error=/path/to/results_dir/01_fastp/fastp_%j.err
#SBATCH --time=00:20:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq

set -euo pipefail # Exit on error, undefined variable, or error in a pipeline

conda_env_name="somatic_variant_calling"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"

# CeMM cluster option
# module load fastp/0.23.2-GCC-11.3.0

SAMPLE="SRR7890883"
IN_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/fastq"
OUT_DIR="/path/to/results_dir/01_fastp"

RAW_R1="${IN_DIR}/${SAMPLE}.chr17_50k_R1.fastq"
RAW_R2="${IN_DIR}/${SAMPLE}.chr17_50k_R2.fastq"
TRIMMED_R1="${OUT_DIR}/${SAMPLE}.chr17_50k_R1_trimmed.fastq"
TRIMMED_R2="${OUT_DIR}/${SAMPLE}.chr17_50k_R2_trimmed.fastq"
FASTP_HTML="${OUT_DIR}/${SAMPLE}.chr17_50k.html"

fastp \
    --in1 "${RAW_R1}" \
    --in2 "${RAW_R2}" \
    --out1 "${TRIMMED_R1}" \
    --out2 "${TRIMMED_R2}" \
    --detect_adapter_for_pe \
    --thread 1 \
    --html "${FASTP_HTML}"