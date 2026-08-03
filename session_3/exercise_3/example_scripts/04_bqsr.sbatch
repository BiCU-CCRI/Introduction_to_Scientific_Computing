#!/bin/bash

#SBATCH --job-name=bqsr
#SBATCH --output=bqsr_%j.out
#SBATCH --error=bqsr_%j.err
#SBATCH --time=00:05:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=3G
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq

set -euo pipefail

# ###########################################################################################################################################################
# Edit these variables before running the script
#############################################################################################################################################################
SAMPLE="SRR7890883"
IN_DIR="/path/to/results/03_markdup"
OUT_DIR="/path/to/results/04_bqsr"
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"
KNOWN_SITES_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/known_sites"
LOG_DIR="/path/to/logs"
#############################################################################################################################################################

conda_env_name="somatic_variant_calling"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"

mkdir -p "${OUT_DIR}"

IN_CRAM="${IN_DIR}/${SAMPLE}.chr17_50k.markdup.cram"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"
RECAL_TABLE="${OUT_DIR}/${SAMPLE}.recal.table"
OUT_CRAM="${OUT_DIR}/${SAMPLE}.recal.cram"
KNOWN_SNPS="${KNOWN_SITES_DIR}/dbsnp_146.hg38.chr17.vcf.gz"
KNOWN_INDELS="${KNOWN_SITES_DIR}/Mills_and_1000G_gold_standard.indels.hg38.chr17.vcf.gz"
LOG_BR="${LOG_DIR}/base_recalibrator_${SAMPLE}.log"
LOG_BQSR="${LOG_DIR}/apply_bqsr_${SAMPLE}.log"

echo "Recalibrating bases for sample ${SAMPLE}"
gatk --java-options "-Xmx10g" BaseRecalibrator \
    -R "${REF}" \
    -I "${IN_CRAM}" \
    --known-sites "${KNOWN_SNPS}" \
    --known-sites "${KNOWN_INDELS}" \
    -O "${RECAL_TABLE}" \
    2> "${LOG_BR}"

echo "Applying BQSR for sample ${SAMPLE}"
gatk --java-options "-Xmx10g" ApplyBQSR \
    -R "${REF}" \
    -I "${IN_CRAM}" \
    --bqsr-recal-file "${RECAL_TABLE}" \
    -O "${OUT_CRAM}" \
    2> "${LOG_BQSR}"

echo "Indexing aligned reads"
samtools index \
    "${OUT_CRAM}"