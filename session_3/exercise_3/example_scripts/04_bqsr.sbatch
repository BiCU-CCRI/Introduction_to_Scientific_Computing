#!/bin/bash

#SBATCH --job-name=bqsr
#SBATCH --output=./logs/bqsr_%j.out
#SBATCH --error=./logs/bqsr_%j.err
#SBATCH --time=00:05:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=3G
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
IN_DIR="/path/to/results/03_markdup"
OUT_DIR="/path/to/results/04_bqsr"
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"
KNOWN_SNPS="/path/to/Introduction_to_Scientific_Computing/example_data/known_sites/dbsnp_146.hg38.chr17.vcf.gz"
KNOWN_INDELS="/path/to/Introduction_to_Scientific_Computing/example_data/known_sites/Mills_and_1000G_gold_standard.indels.hg38.chr17.vcf.gz"
LOG_BR="/path/to/logs/base_recalibrator_${SAMPLE}.log"
LOG_BQSR="/path/to/logs/apply_bqsr_${SAMPLE}.log"

mkdir -p "${OUT_DIR}"

IN_CRAM="${IN_DIR}/${SAMPLE}.chr17_50k.markdup.cram"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"
RECAL_TABLE="${OUT_DIR}/${SAMPLE}.recal.table"
OUT_CRAM="${OUT_DIR}/${SAMPLE}.recal.cram"

gatk --java-options "-Xmx10g" BaseRecalibrator \
    -R "${REF}" \
    -I "${IN_CRAM}" \
    --known-sites "${KNOWN_SNPS}" \
    --known-sites "${KNOWN_INDELS}" \
    -O "${RECAL_TABLE}" \
    2> "${LOG_BR}"

gatk --java-options "-Xmx10g" ApplyBQSR \
    -R "${REF}" \
    -I "${IN_CRAM}" \
    --bqsr-recal-file "${RECAL_TABLE}" \
    -O "${OUT_CRAM}" \
    2> "${LOG_BQSR}"

samtools index \
    -@ "${SLURM_CPUS_PER_TASK}" \
    "${OUT_CRAM}"