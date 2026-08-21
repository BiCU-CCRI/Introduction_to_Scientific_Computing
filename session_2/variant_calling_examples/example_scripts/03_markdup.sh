#!/bin/bash

set -euo pipefail

SAMPLE="SRR7890883"
IN_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/results/02_bwa"
OUT_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/results/03_markdup"
REF_DIR="/workspaces/Introduction_to_Scientific_Computing/example_data/ref"
LOG_DIR="/workspaces/Introduction_to_Scientific_Computing/session_2/variant_calling_work_dir/logs/03_markdup"

mkdir -p "${OUT_DIR}"
mkdir -p "${LOG_DIR}"

IN_BAM="${IN_DIR}/${SAMPLE}.chr17_50k.bam"
OUT_BAM="${OUT_DIR}/${SAMPLE}.chr17_50k.markdup.bam"
METRICS="${OUT_DIR}/${SAMPLE}.markdup.metrics.txt"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta.gz"
LOG="${LOG_DIR}/${SAMPLE}.markdup.log"

echo "Marking duplicate reads for sample ${SAMPLE}"
gatk --java-options "-Xmx5g" MarkDuplicates \
    --INPUT "${IN_BAM}" \
    --OUTPUT "${OUT_BAM}" \
    --METRICS_FILE "${METRICS}" \
    --REFERENCE_SEQUENCE "${REF}" \
    --CREATE_INDEX true \
    --VALIDATION_STRINGENCY SILENT \
    --OPTICAL_DUPLICATE_PIXEL_DISTANCE 2500 \
    > "${LOG}" 2>&1

echo "All done."

