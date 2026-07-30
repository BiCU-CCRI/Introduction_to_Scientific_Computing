#!/bin/bash

#SBATCH --job-name=mutect2
#SBATCH --output=/path/to/results_dir/05_mutect2/mutect2_%j.out
#SBATCH --error=/path/to/results_dir/05_mutect2/mutect2_%j.err
#SBATCH --time=02:00:00
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
IN_DIR="/path/to/results_dir/04_bqsr"
OUT_DIR="/path/to/results_dir/05_mutect2"

IN_CRAM="${IN_DIR}/${SAMPLE}.recal.cram"

UNFILTERED_VCF="${OUT_DIR}/${SAMPLE}.unfiltered.vcf.gz"
F1R2="${OUT_DIR}/${SAMPLE}.f1r2.tar.gz"
ORIENTATION_MODEL="${OUT_DIR}/${SAMPLE}.read-orientation-model.tar.gz"

PILEUPS="${OUT_DIR}/${SAMPLE}.pileups.table"
CONTAMINATION="${OUT_DIR}/${SAMPLE}.contamination.table"
SEGMENTS="${OUT_DIR}/${SAMPLE}.segments.table"

FILTERED_VCF="${OUT_DIR}/${SAMPLE}.filtered.vcf.gz"
PASS_VCF="${OUT_DIR}/${SAMPLE}.pass.vcf.gz"

INTERVAL_ARGS=()
PON_ARGS=()

if [[ -n "${INTERVALS}" ]]; then
    INTERVAL_ARGS=(-L "${INTERVALS}")
fi

if [[ -n "${PON}" ]]; then
    PON_ARGS=(--panel-of-normals "${PON}")
fi

gatk --java-options "-Xmx10g" Mutect2 \
    -R "${REF}" \
    -I "${BAM}" \
    --germline-resource "${GERMLINE_RESOURCE}" \
    "${PON_ARGS[@]}" \
    "${INTERVAL_ARGS[@]}" \
    --f1r2-tar-gz "${F1R2}" \
    -O "${UNFILTERED_VCF}" \
    2> "${OUT_DIR}/${SAMPLE}.mutect2.log"

gatk --java-options "-Xmx10g" LearnReadOrientationModel \
    -I "${F1R2}" \
    -O "${ORIENTATION_MODEL}" \
    2> "${OUT_DIR}/${SAMPLE}.orientation_model.log"

gatk --java-options "-Xmx10g" GetPileupSummaries \
    -R "${REF}" \
    -I "${BAM}" \
    -V "${CONTAMINATION_SITES}" \
    -L "${CONTAMINATION_SITES}" \
    -O "${PILEUPS}" \
    2> "${OUT_DIR}/${SAMPLE}.get_pileup_summaries.log"

gatk --java-options "-Xmx56g" CalculateContamination \
    -I "${PILEUPS}" \
    -O "${CONTAMINATION}" \
    --tumor-segmentation "${SEGMENTS}" \
    2> "${OUT_DIR}/${SAMPLE}.calculate_contamination.log"

gatk --java-options "-Xmx56g" FilterMutectCalls \
    -R "${REF}" \
    -V "${UNFILTERED_VCF}" \
    --contamination-table "${CONTAMINATION}" \
    --tumor-segmentation "${SEGMENTS}" \
    --ob-priors "${ORIENTATION_MODEL}" \
    "${INTERVAL_ARGS[@]}" \
    -O "${FILTERED_VCF}" \
    2> "${OUT_DIR}/${SAMPLE}.filter_mutect_calls.log"

gatk --java-options "-Xmx10g" SelectVariants \
    -R "${REF}" \
    -V "${FILTERED_VCF}" \
    --exclude-filtered true \
    -O "${PASS_VCF}" \
    2> "${OUT_DIR}/${SAMPLE}.select_pass_variants.log"

gatk IndexFeatureFile \
    -I "${PASS_VCF}"

echo "Filtered VCF: ${FILTERED_VCF}"
echo "PASS VCF:     ${PASS_VCF}"