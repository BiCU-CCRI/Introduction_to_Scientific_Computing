#!/bin/bash

#SBATCH --job-name=example_job
#SBATCH --time=00:10:00
#SBATCH --mem=1G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --output=example_job_%j.out
#SBATCH --error=example_job_%j.err

echo "This is an example job script."