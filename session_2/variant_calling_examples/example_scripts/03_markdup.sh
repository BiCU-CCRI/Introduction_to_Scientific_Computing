#!/bin/bash

set -euo pipefail

# ###########################################################################################################################################################
# Edit these variables before running the script
#############################################################################################################################################################
SAMPLE="SRR7890883"
IN_DIR="/path/to/results/02_bwa"
OUT_DIR="/path/to/results/03_markdup"
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"
LOG="/path/to/logs/markdup_${SAMPLE}.log"
#############################################################################################################################################################

mkdir -p "${OUT_DIR}"

IN_CRAM="${IN_DIR}/${SAMPLE}.chr17_50k.cram"
OUT_CRAM="${OUT_DIR}/${SAMPLE}.chr17_50k.markdup.cram"
METRICS="${OUT_DIR}/${SAMPLE}.markdup.metrics.txt"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"

echo "Marking duplicate reads for sample ${SAMPLE}"
gatk --java-options "-Xmx10g" MarkDuplicates \
    --INPUT "${IN_CRAM}" \
    --OUTPUT "${OUT_CRAM}" \
    --METRICS_FILE "${METRICS}" \
    --REFERENCE_SEQUENCE "${REF}" \
    --CREATE_INDEX true \
    --VALIDATION_STRINGENCY SILENT \
    --OPTICAL_DUPLICATE_PIXEL_DISTANCE 2500 > "${LOG}" 2>&1