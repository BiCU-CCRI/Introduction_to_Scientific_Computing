#!/bin/bash

#SBATCH --job-name=mark_dup
#SBATCH --output=/path/to/results_dir/03_mark_dup/mark_dup_%j.out
#SBATCH --error=/path/to/results_dir/03_mark_dup/mark_dup_%j.err
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

INPUT_CRAM="/path/to/results_dir/02_bwa/SRR7890883.chr17_50k.cram"
OUTPUT_CRAM="/path/to/results_dir/03_mark_dup/SRR7890883.chr17_50k.markdup.cram"
METRICS="/path/to/results_dir/03_mark_dup/SRR7890883.markdup.metrics.txt"
REF="/path/to/Introduction_to_Scientific_Computing/example_data/ref/Homo_sapiens_assembly38.chr17.fasta"

gatk --java-options "-Xmx10g" MarkDuplicates \
    --INPUT "${INPUT_CRAM}" \
    --OUTPUT "${OUTPUT_CRAM}" \
    --METRICS_FILE "${METRICS}" \
    --REFERENCE_SEQUENCE "${REF}" \
    --CREATE_INDEX true \
    --VALIDATION_STRINGENCY SILENT \
    --OPTICAL_DUPLICATE_PIXEL_DISTANCE 2500