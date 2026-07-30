#!/bin/bash

#SBATCH --job-name=bqsr
#SBATCH --output=/path/to/results_dir/04_bqsr/bqsr_%j.out
#SBATCH --error=/path/to/results_dir/04_bqsr/bqsr_%j.err
#SBATCH --time=00:10:00
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
# modue load GATK/4.2.0.0-GCCcore-10.2.0-Java-11
# module load SAMtools/1.17-GCC-11.3.0

SAMPLE="SRR7890883"
IN_DIR="/path/to/results_dir/03_markdup"
OUT_DIR="/path/to/results_dir/04_bqsr"
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"

IN_CRAM="${IN_DIR}/${SAMPLE}.chr17_50k.markdup.cram"
RECAL_TABLE="${OUT_DIR}/${SAMPLE}.recal.table"
OUT_CRAM="${OUT_DIR}/${SAMPLE}.recal.cram"

INTERVAL_ARGS=()

if [[ -n "${INTERVALS}" ]]; then
    INTERVAL_ARGS=(-L "${INTERVALS}")
fi

gatk --java-options "-Xmx10g" BaseRecalibrator \
    -R "${REF}" \
    -I "${IN_CRAM}" \
    --known-sites "${DBSNP}" \
    --known-sites "${KNOWN_INDELS}" \
    "${INTERVAL_ARGS[@]}" \
    -O "${RECAL_TABLE}" \
    2> "${OUT_DIR}/${SAMPLE}.base_recalibrator.log"

gatk --java-options "-Xmx10g" ApplyBQSR \
    -R "${REF}" \
    -I "${IN_CRAM}" \
    --bqsr-recal-file "${RECAL_TABLE}" \
    "${INTERVAL_ARGS[@]}" \
    -O "${OUT_CRAM}" \
    2> "${OUT_DIR}/${SAMPLE}.apply_bqsr.log"

samtools index \
    -@ "${SLURM_CPUS_PER_TASK}" \
    "${OUT_CRAM}"