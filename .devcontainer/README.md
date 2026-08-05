# SLURM training devcontainer

Opens a small real SLURM cluster (not a simulation) inside Codespaces, consisting of:
- `login-01` (login node) 
- `node001`-`node004` (compute nodes). 

The container opens as user `codespace` on node `login-01`, with 
`/workspaces/Introduction_to_Scientific_Computing` as the working directory.

## Notes

- **No default partition/QOS.** Every `sbatch`/`salloc`/`srun` needs an
  explicit `--partition=<name>` (and usually `--qos=<name>` matching
  it), mirroring the real CeMM cluster. Partitions: `tinyq`,
  `interactiveq`, `develop`, `shortq`, `mediumq`, `longq`, `covid`,
  `gpu`.
- **`gpu` partition has no node.** Jobs submitted there stay PENDING -
  there's no GPU worker in this environment.
- **Node/memory counts don't match the real cluster.** Only 4 compute
  nodes exist regardless of what the real queue table says; queue time
  limits and per-QOS `GrpJobs`/`MaxJobsPerUser` do match.
- **`squeue` shows other "trainees'" jobs** (alice/bob/carol/dave/eve) -
  these are seeded on container creation so the queue isn't empty on
  first login.


## Commands that work here

All of these behave like a real cluster (not a simulation), so
`--partition`/`--qos` are always required:

- `sinfo` - node/partition states.
- `squeue`, `squeue --me`, `squeue -p <partition>` - queue status.
- `sbatch --partition=<p> --qos=<p> script.sbatch` - submit a batch job.
- `salloc --partition=<p> --qos=<p> --time=... --mem=... --cpus-per-task=...`
  - allocate resources; run in the same shell.
- `srun --pty bash` - inside an active `salloc`, drop into a shell on
  the allocated compute node.
- `srun --partition=<p> --qos=<p> ... <command>` - submit and run a
  command directly, without a prior `salloc`.
- `scontrol show job <job_id>` - full detail on one job.
- `scontrol update JobId=<job_id> timelimit=<new_time>` - change a
  running/pending job's time limit.
- `seff <job_id>` - CPU/memory efficiency of a completed job (also
  actually works here).
- `sacct` - history of completed jobs.
- `scancel <job_id>` - cancel a job.

## Troubleshooting

**`srun: error: Unable to confirm allocation for job N: Invalid job id
specified` / "Expired or invalid job N"**

Your shell still has `SLURM_JOB_ID` set from a previous `salloc` that
has since ended, so `srun` tries to reattach to that dead job instead
of submitting a new one. Fix:

```
unset SLURM_JOB_ID
```

or just open a new terminal.