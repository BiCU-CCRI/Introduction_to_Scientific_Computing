#!/bin/bash

set -euo pipefail

SAMPLE="SRR7890883"
IN_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/results/04_bqsr"
OUT_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/results/05_mutect2"
REF_DIR="/workspaces/Introduction_to_Scientific_Computing/example_data/ref"
GERM_DIR="/workspaces/Introduction_to_Scientific_Computing/example_data/germline_resource"
LOG_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/logs/05_mutect2"

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