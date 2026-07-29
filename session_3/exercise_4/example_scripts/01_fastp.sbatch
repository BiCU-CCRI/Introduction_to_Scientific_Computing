#!/bin/bash

#SBATCH --job-name=fastp
#SBATCH --output=/path/to/results_dir/01_fastp/fastp_%j.out
#SBATCH --error=/path/to/results_dir/01_fastp/fastp_%j.err
#SBATCH --time=00:20:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq

set -euo pipefail # Exit on error, undefined variable, or error in a pipeline

conda_env_name="somatic_variant_calling"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"

# CeMM cluster option
# module load fastp/0.23.2-GCC-11.3.0

fastp \
    --in1 /path/to/Introduction_to_Scientific_Computing/example_data/fastq/SRR7890883.chr17_50k_R1.fastq \
    --in2 /path/to/Introduction_to_Scientific_Computing/example_data/fastq/SRR7890883.chr17_50k_R2.fastq \
    --out1 /path/to/results_dir/01_fastp/SRR7890883.chr17_50k_R1_trimmed.fastq \
    --out2 /path/to/results_dir/01_fastp/SRR7890883.chr17_50k_R2_trimmed.fastq \
    --detect_adapter_for_pe \
    --thread 1 \
    --html /path/to/results_dir/01_fastp/SRR7890883.chr17_50k.html