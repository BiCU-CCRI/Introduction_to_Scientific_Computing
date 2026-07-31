#!/bin/bash
#SBATCH --partition=interactiveq
#SBATCH --qos=interactiveq
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=12:00:00
#SBATCH --job-name=jupyter-lab
#SBATCH --output=jupyter-lab-%j.log

conda_env_name="intro_to_sci_comp"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"

port=$(shuf -i8000-9000 -n1)
node=$(hostname).int.cemm.at
user=$(whoami)
host ${node}

jupyter lab --no-browser --port=${port} --ip=${node}
