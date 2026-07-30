#!/bin/bash

#SBATCH --job-name=bwa
#SBATCH --output=/path/to/results_dir/02_bwa/bwa_%j.out
#SBATCH --error=/path/to/results_dir/02_bwa/bwa_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq

set -euo pipefail # Exit on error, undefined variable, or error in a pipeline

conda_env_name="somatic_variant_calling"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"

# CeMM cluster option
# module load BWA/0.7.17-GCCcore-11.3.0
# module load SAMtools/1.17-GCC-11.3.0

SAMPLE="SRR7890883"
IN_DIR="/path/to/results_dir/01_fastp"
OUT_DIR="/path/to/results_dir/02_bwa"
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"

LIBRARY="lib1"
PLATFORM="ILLUMINA"
FASTP_R1="${IN_DIR}/${SAMPLE}.chr17_50k_R1_trimmed.fastq"
FASTP_R2="${IN_DIR}/${SAMPLE}.chr17_50k_R2_trimmed.fastq"
OUT_CRAM="${OUT_DIR}/${SAMPLE}.chr17_50k.cram"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"

READ_GROUP="@RG\tID:${SAMPLE}.${LIBRARY}\tSM:${SAMPLE}\tLB:${LIBRARY}\tPL:${PLATFORM}\tPU:${SAMPLE}.${LIBRARY}"

bwa mem \
    -t 1 \
    -M \
    -R "${READ_GROUP}" \
    "${REF}" \
    "${FASTP_R1}" \
    "${FASTP_R2}" \
    2> "${OUT_DIR}/${SAMPLE}.bwa.log" |
samtools sort \
    -@ 1 \
    -O CRAM \
    --reference "${REF}" \
    -o "${OUT_CRAM}" \
    -

samtools index \
    -@ 1 \
    "${OUT_CRAM}"