#!/bin/bash
# Submits jobs under fake trainee accounts so squeue/sacct show a
# realistic mix of running/pending jobs instead of an empty queue when
# trainees first look. Some requests are small enough to actually run;
# others deliberately exceed the 4-node cluster size and stay PENDING
# (reason: Resources) - mirroring the example squeue output in the
# session material. Idempotent-ish: harmless to re-run, just adds more.
set -e

until scontrol ping >/dev/null 2>&1; do sleep 2; done

# --mem is explicit on the runnable jobs so they don't default to
# claiming a whole node's memory (cons_tres with no DefMemPerCPU/--mem
# grants everything available), which would starve real trainee jobs.
sudo -u alice sbatch --job-name=openfoam_run --partition=mediumq --qos=mediumq \
  --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=256M --time=2:00:00 --wrap="sleep 7200" >/dev/null 2>&1 || true
sudo -u bob   sbatch --job-name=gromacs_md   --partition=shortq  --qos=shortq \
  --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=256M --time=1:00:00 --wrap="sleep 3600" >/dev/null 2>&1 || true
sudo -u carol sbatch --job-name=ml_train     --partition=gpu     --qos=gpu \
  --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=256M --time=3:00:00 --wrap="sleep 10800" >/dev/null 2>&1 || true

sudo -u dave  sbatch --job-name=postprocess  --partition=mediumq --qos=mediumq \
  --nodes=8 --ntasks=8 --mem=256M --time=1:00:00 --wrap="sleep 3600" >/dev/null 2>&1 || true
sudo -u eve   sbatch --job-name=wrf_d02      --partition=shortq  --qos=shortq \
  --nodes=6 --ntasks=6 --mem=256M --time=2:00:00 --wrap="sleep 7200" >/dev/null 2>&1 || true
sudo -u alice sbatch --job-name=bigmem_job   --partition=longq   --qos=longq \
  --nodes=4 --ntasks=4 --mem=256M --time=1:00:00 --wrap="sleep 3600" >/dev/null 2>&1 || true

echo "Seeded fake jobs:"
squeue
