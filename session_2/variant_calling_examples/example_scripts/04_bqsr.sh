#!/bin/bash

set -euo pipefail

SAMPLE="SRR7890883"
IN_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/results/03_markdup"
OUT_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/results/04_bqsr"
REF_DIR="/workspaces/Introduction_to_Scientific_Computing/example_data/ref"
KNOWN_SITES_DIR="/workspaces/Introduction_to_Scientific_Computing/example_data/known_sites"
LOG_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/logs/04_bqsr"

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
gatk --java-options "-Xmx10g" BaseRecalibrator \
    -R "${REF}" \
    -I "${IN_BAM}" \
    --known-sites "${KNOWN_SNPS}" \
    --known-sites "${KNOWN_INDELS}" \
    -O "${RECAL_TABLE}" \
    2> "${LOG_BR}"

echo "Applying BQSR for sample ${SAMPLE}"
gatk --java-options "-Xmx10g" ApplyBQSR \
    -R "${REF}" \
    -I "${IN_BAM}" \
    --bqsr-recal-file "${RECAL_TABLE}" \
    -O "${OUT_BAM}" \
    2> "${LOG_BQSR}"

echo "Indexing aligned reads"
samtools index \
    "${OUT_BAM}"