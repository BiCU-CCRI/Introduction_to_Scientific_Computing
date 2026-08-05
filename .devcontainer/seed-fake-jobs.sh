#!/bin/bash
# Submits jobs under fake trainee accounts so squeue/sacct show a
# realistic mix of running/pending jobs instead of an empty queue when
# trainees first look. Pending reasons are chosen to match the ones the
# session material's exercise explicitly explains (Resources, Dependency,
# QOSGrpJobsLimit) rather than incidental ones a real scheduler would also
# produce (e.g. PartitionNodeLimit) but that aren't covered in the doc.
# Idempotent-ish: harmless to re-run, just adds more.
set -e

until scontrol ping >/dev/null 2>&1; do sleep 2; done

# --mem is explicit on the runnable jobs so they don't default to
# claiming a whole node's memory (cons_tres with no DefMemPerCPU/--mem
# grants everything available), which would starve real trainee jobs.
sudo -u alice sbatch --job-name=openfoam_run --partition=mediumq --qos=mediumq \
  --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=256M --time=2:00:00 --wrap="sleep 7200" >/dev/null 2>&1 || true
sudo -u bob   sbatch --job-name=gromacs_md   --partition=shortq  --qos=shortq \
  --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=256M --time=1:00:00 --wrap="sleep 3600" >/dev/null 2>&1 || true

# Reason: Resources - legitimately oversized within the 4-node cluster.
sudo -u alice sbatch --job-name=bigmem_job   --partition=longq   --qos=longq \
  --nodes=4 --ntasks=4 --mem=256M --time=1:00:00 --wrap="sleep 3600" >/dev/null 2>&1 || true

# Reason: Dependency - waits on openfoam_run above, regardless of cluster load.
OPENFOAM_JOBID=$(sudo -u alice sbatch --parsable --job-name=openfoam_run2 --partition=mediumq --qos=mediumq \
  --nodes=1 --ntasks=1 --mem=128M --time=2:00:00 --wrap="sleep 7200" 2>/dev/null) || true
if [ -n "$OPENFOAM_JOBID" ]; then
  sudo -u dave sbatch --job-name=postprocess --partition=mediumq --qos=mediumq \
    --nodes=1 --ntasks=1 --mem=128M --time=1:00:00 \
    --dependency=afterany:"$OPENFOAM_JOBID" --wrap="sleep 3600" >/dev/null 2>&1 || true
fi

# Reason: QOSGrpJobsLimit - develop QOS caps at GrpJobs=5 running jobs, so
# once 5 are running, a 6th pends on this specific reason.
for u in alice bob carol dave eve; do
  sudo -u "$u" sbatch --job-name=dev_task --partition=develop --qos=develop \
    --nodes=1 --ntasks=1 --mem=128M --time=0:10:00 --wrap="sleep 600" >/dev/null 2>&1 || true
done
sudo -u eve sbatch --job-name=wrf_d02 --partition=develop --qos=develop \
  --nodes=1 --ntasks=1 --mem=128M --time=0:10:00 --wrap="sleep 600" >/dev/null 2>&1 || true

echo "Seeded fake jobs:"
squeue
