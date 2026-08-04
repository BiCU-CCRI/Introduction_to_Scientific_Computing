#!/bin/bash

set -euo pipefail

# ###########################################################################################################################################################
# Edit these variables before running the script
#############################################################################################################################################################
SAMPLE="SRR7890883"
IN_DIR="/path/to/results/04_bqsr"
OUT_DIR="/path/to/results/05_mutect2"
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"
GERM_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/germline_resource"
LOG_DIR="/path/to/logs"
#############################################################################################################################################################

mkdir -p "${OUT_DIR}"

IN_CRAM="${IN_DIR}/${SAMPLE}.recal.cram"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"
GERMLINE_RESOURCE="${GERM_DIR}/gnomAD.r2.1.1.GRCh38.chr17.75pct.PASS.AC.AF.only.vcf.gz"

UNFILTERED_VCF="${OUT_DIR}/${SAMPLE}.unfiltered.vcf.gz"
FILTERED_VCF="${OUT_DIR}/${SAMPLE}.filtered.vcf.gz"
PASS_VCF="${OUT_DIR}/${SAMPLE}.pass.vcf.gz"

echo "Running Mutect2 on sample ${SAMPLE}"
gatk --java-options "-Xmx10g" Mutect2 \
    -R "${REF}" \
    -I "${IN_CRAM}" \
    --germline-resource "${GERMLINE_RESOURCE}" \
    -O "${UNFILTERED_VCF}" \
    2> "${LOG_DIR}/mutect2.${SAMPLE}.log"

echo "Filtering Mutect2 calls"
gatk --java-options "-Xmx10g" FilterMutectCalls \
    -R "${REF}" \
    -V "${UNFILTERED_VCF}" \
    -O "${FILTERED_VCF}" \
    2> "${LOG_DIR}/mutect2.filter_mutect_calls.${SAMPLE}.log"

echo "Selecting PASS variants"
gatk --java-options "-Xmx10g" SelectVariants \
    -R "${REF}" \
    -V "${FILTERED_VCF}" \
    --exclude-filtered true \
    -O "${PASS_VCF}" \
    2> "${LOG_DIR}/mutect2.select_pass_variants.${SAMPLE}.log"

echo "Filtered VCF: ${FILTERED_VCF}"
echo "PASS VCF:     ${PASS_VCF}"