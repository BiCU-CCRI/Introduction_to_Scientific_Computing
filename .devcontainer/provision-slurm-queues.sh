#!/bin/sh
# Registers the CeMM-style QOS/partition pairs with slurmdbd and grants the
# training user access to all of them. Idempotent - safe to re-run.
set -e

until scontrol ping >/dev/null 2>&1; do
  echo "Waiting for slurmctld..."
  sleep 2
done

sacctmgr -i add cluster linux                                          2>/dev/null || true
sacctmgr -i add account users                                          2>/dev/null || true

sacctmgr -i add qos tinyq        set MaxWall=02:00:00    GrpJobs=400   2>/dev/null || true
sacctmgr -i add qos interactiveq set MaxWall=12:00:00    MaxJobsPerUser=1 2>/dev/null || true
sacctmgr -i add qos develop      set MaxWall=01:00:00    GrpJobs=5     2>/dev/null || true
sacctmgr -i add qos shortq       set MaxWall=12:00:00    GrpJobs=200   2>/dev/null || true
sacctmgr -i add qos mediumq      set MaxWall=2-00:00:00  GrpJobs=50    2>/dev/null || true
sacctmgr -i add qos longq        set MaxWall=30-00:00:00 GrpJobs=30    2>/dev/null || true
sacctmgr -i add qos covid        set MaxWall=20-00:00:00               2>/dev/null || true
sacctmgr -i add qos gpu          set MaxWall=3-00:00:00                2>/dev/null || true

sacctmgr -i add user root account=users \
  qos=tinyq,interactiveq,develop,shortq,mediumq,longq,covid,gpu \
  defaultqos=tinyq                                                     2>/dev/null || true

echo "SLURM queues ready:"
sinfo
