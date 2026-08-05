#!/bin/bash

#SBATCH --job-name=bqsr
#SBATCH --output=logs/slurm_logs/bqsr_%j.out
#SBATCH --error=logs/slurm_logs/bqsr_%j.err
#SBATCH --time=00:05:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq

set -euo pipefail

module load GATK/4.1.8.1-GCCcore-9.3.0-Java-1.8
module load SAMtools/1.18-GCC-12.3.0

SAMPLE="SRR7890883"
IN_DIR="results/03_markdup"
OUT_DIR="results/04_bqsr"
LOG_DIR="logs/04_bqsr"
REF_DIR="../../example_data/ref"
KNOWN_SITES_DIR="../../example_data/known_sites"

mkdir -p "${OUT_DIR}"
mkdir -p "${LOG_DIR}"

IN_BAM="${IN_DIR}/${SAMPLE}.chr17_50k.markdup.bam"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"
RECAL_TABLE="${OUT_DIR}/${SAMPLE}.recal.table"
OUT_BAM="${OUT_DIR}/${SAMPLE}.recal.bam"
KNOWN_SNPS="${KNOWN_SITES_DIR}/dbsnp_146.hg38.chr17.vcf.gz"
KNOWN_INDELS="${KNOWN_SITES_DIR}/Mills_and_1000G_gold_standard.indels.hg38.chr17.vcf.gz"
LOG_BR="${LOG_DIR}/${SAMPLE}.base_recalibrator.log"
LOG_BQSR="${LOG_DIR}/${SAMPLE}.apply_bqsr.log"

echo "Recalibrating bases for sample ${SAMPLE}"
gatk --java-options "-Xmx5g" BaseRecalibrator \
    -R "${REF}" \
    -I "${IN_BAM}" \
    --known-sites "${KNOWN_SNPS}" \
    --known-sites "${KNOWN_INDELS}" \
    -O "${RECAL_TABLE}" \
    2> "${LOG_BR}"

echo "Applying BQSR for sample ${SAMPLE}"
gatk --java-options "-Xmx5g" ApplyBQSR \
    -R "${REF}" \
    -I "${IN_BAM}" \
    --bqsr-recal-file "${RECAL_TABLE}" \
    -O "${OUT_BAM}" \
    2> "${LOG_BQSR}"

echo "Indexing aligned reads"
samtools index \
    "${OUT_BAM}"