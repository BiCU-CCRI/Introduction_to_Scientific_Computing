#!/bin/bash

#SBATCH --job-name=mutect2
#SBATCH --output=./logs/mutect2_%j.out
#SBATCH --error=./logs/mutect2_%j.err
#SBATCH --time=00:20:00
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

SAMPLE="SRR7890883"
IN_DIR="/path/to/Introduction_to_Scientific_Computing/session_3/exercise_3/expected_outputs/results/04_bqsr"
OUT_DIR="/path/to/Introduction_to_Scientific_Computing/session_3/exercise_3/expected_outputs/results/05_mutect2"
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"
GERM_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/germline_resource"
LOG_DIR="/path/to/logs"

mkdir -p "${OUT_DIR}"

IN_CRAM="${IN_DIR}/${SAMPLE}.recal.cram"
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"
GERMLINE_RESOURCE="${GERM_DIR}/gnomAD.r2.1.1.GRCh38.chr17.PASS.AC.AF.only.vcf.gz"

UNFILTERED_VCF="${OUT_DIR}/${SAMPLE}.unfiltered.vcf.gz"
FILTERED_VCF="${OUT_DIR}/${SAMPLE}.filtered.vcf.gz"
PASS_VCF="${OUT_DIR}/${SAMPLE}.pass.vcf.gz"

gatk --java-options "-Xmx10g" Mutect2 \
    -R "${REF}" \
    -I "${IN_CRAM}" \
    --germline-resource "${GERMLINE_RESOURCE}" \
    -O "${UNFILTERED_VCF}" \
    2> "${LOG_DIR}/mutect2.${SAMPLE}.log"

gatk --java-options "-Xmx56g" FilterMutectCalls \
    -R "${REF}" \
    -V "${UNFILTERED_VCF}" \
    -O "${FILTERED_VCF}" \
    2> "${LOG_DIR}/mutect2.filter_mutect_calls.${SAMPLE}.log"

gatk --java-options "-Xmx10g" SelectVariants \
    -R "${REF}" \
    -V "${FILTERED_VCF}" \
    --exclude-filtered true \
    -O "${PASS_VCF}" \
    2> "${LOG_DIR}/mutect2.select_pass_variants.${SAMPLE}.log"

echo "Filtered VCF: ${FILTERED_VCF}"
echo "PASS VCF:     ${PASS_VCF}"