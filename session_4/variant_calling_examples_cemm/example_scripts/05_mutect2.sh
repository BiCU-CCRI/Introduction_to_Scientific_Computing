#!/bin/bash

#SBATCH --job-name=mutect2
#SBATCH --output=logs/slurm_logs/mutect2_%j.out
#SBATCH --error=logs/slurm_logs/mutect2_%j.err
#SBATCH --time=00:10:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq

set -euo pipefail

module load GATK/4.1.8.1-GCCcore-9.3.0-Java-1.8

SAMPLE="SRR7890883"
IN_DIR="results/04_bqsr"
OUT_DIR="results/05_mutect2"
LOG_DIR="logs/05_mutect2"
REF_DIR="../../example_data/ref"
GERM_DIR="../../example_data/germline_resource"

mkdir -p "${OUT_DIR}"
mkdir -p "${LOG_DIR}"

IN_BAM="${IN_DIR}/${SAMPLE}.recal.bam"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"
GERMLINE_RESOURCE="${GERM_DIR}/gnomAD.r2.1.1.GRCh38.chr17.75pct.PASS.AC.AF.only.vcf.gz"
UNFILTERED_VCF="${OUT_DIR}/${SAMPLE}.unfiltered.vcf.gz"
FILTERED_VCF="${OUT_DIR}/${SAMPLE}.filtered.vcf.gz"
PASS_VCF="${OUT_DIR}/${SAMPLE}.pass.vcf.gz"

echo "Running Mutect2 on sample ${SAMPLE}"
gatk --java-options "-Xmx10g" Mutect2 \
    -R "${REF}" \
    -I "${IN_BAM}" \
    --germline-resource "${GERMLINE_RESOURCE}" \
    -O "${UNFILTERED_VCF}" \
    2> "${LOG_DIR}/${SAMPLE}.mutect2.log"

echo "Filtering Mutect2 calls"
gatk --java-options "-Xmx10g" FilterMutectCalls \
    -R "${REF}" \
    -V "${UNFILTERED_VCF}" \
    -O "${FILTERED_VCF}" \
    2> "${LOG_DIR}/${SAMPLE}.filter_mutect_calls.log"

echo "Selecting PASS variants"
gatk --java-options "-Xmx10g" SelectVariants \
    -R "${REF}" \
    -V "${FILTERED_VCF}" \
    --exclude-filtered true \
    -O "${PASS_VCF}" \
    2> "${LOG_DIR}/${SAMPLE}.select_pass_variants.log"

echo "Filtered VCF: ${FILTERED_VCF}"
echo "PASS VCF:     ${PASS_VCF}"