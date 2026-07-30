#!/bin/bash

#SBATCH --job-name=mark_dup
#SBATCH --output=/path/to/results_dir/03_markdup/markdup_%j.out
#SBATCH --error=/path/to/results_dir/03_markdup/markdup_%j.err
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq

set -euo pipefail

conda_env_name="somatic_variant_calling"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"

# CeMM cluster option
# module load GATK/4.2.0.0-GCCcore-10.2.0-Java-11

SAMPLE="SRR7890883"
IN_DIR="/path/to/results_dir/02_bwa"
OUT_DIR="/path/to/results_dir/03_markdup"
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"

IN_CRAM="${IN_DIR}/${SAMPLE}.chr17_50k.cram"
OUT_CRAM="${OUT_DIR}/${SAMPLE}.chr17_50k.markdup.cram"
METRICS="${OUT_DIR}/${SAMPLE}.markdup.metrics.txt"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"

gatk --java-options "-Xmx10g" MarkDuplicates \
    --INPUT "${IN_CRAM}" \
    --OUTPUT "${OUT_CRAM}" \
    --METRICS_FILE "${METRICS}" \
    --REFERENCE_SEQUENCE "${REF}" \
    --CREATE_INDEX true \
    --VALIDATION_STRINGENCY SILENT \
    --OPTICAL_DUPLICATE_PIXEL_DISTANCE 2500