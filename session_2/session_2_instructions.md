# Introduction to Scientific Computing - Session 1  

Welcome to Session 2 of the Introduction to Scientific Computing course! Glad to see you enjoyed Session 1 enough to come back for more.  

## Overview
  
Today we'll cover:  

1. Exercise 1: Learning when to use a compute node instead of a login node  
2. SLURM basics  
3. SLURM directives  
4. SLURM queues  
5. Exercise 2: Using `srun` to start an interactive job  
6. Exercise 3: Running simple commands and scripts using the command line on a compute node via an interactive job  
7. Exercise 4: Running a simple `.sbatch` script on a compute node  
8. Exercise 5: Useful commands to track cluster usage and job status  

Since this session is mostly about learning how to work with SLURM, you will either need a CeMM cluster account, or to use the simulated SLURM environment "LearnSlurm".  

## Exercise 1: Learning when to use a compute node instead of a login node

**Goal:** Learn to decide when to use a compute node instead of a login node.  

So far, we have been running simple commands on the login node. This is fine for small tasks, but if you want to run more complex or resource-intensive tasks, you will need to use a compute node.  

The CeMM cluster login nodes have limited resources, and running resource-intensive tasks on them can slow down the system for everyone. Compute nodes, on the other hand, are designed to handle more demanding workloads.  

To decide whether to use a compute node or a login node, consider the following:

- Will my task require a lot of memory (> 1 GB)?  
- Will my task take a long time to complete (> 1 hour)?  
- Is my task suitable for parallel processing (using >1 CPU core)?  

If the answer to any of these questions is yes, then you should use a compute node. If you don't know the answer to these, stay safe and use a compute node.  

Test yourself with the following examples:  

1. You want to list the files in a directory.  
2. You want to perform a somatic variant calling analysis.  
3. You want to generate a small plot from a small dataset.  
4. You want to generate a small plot from a large dataset.  
5. You want to test a pipeline that processes a small dataset.  
6. You want to download a genome reference from the internet.  
7. You don't know how long your task will take to complete or how much memory it will use.  
8. You want to check the status of your jobs.

Answers:

1. Use a login node. This is a quick and simple task that doesn't require much memory or time.  
2. Use a compute node. This task is resource-intensive and will take a long time to complete, so it's best to run it on a compute node.  
3. Use a login node. Generating a small plot is a quick task that doesn't require much memory or time, so it's fine to run it on a login node.  
4. Use a compute node. Even though generating a plot may seem like a simple task, if the dataset is large, loading the data into memory may take a long time and use a lot of memory.  
5. Use a compute node. Even though the dataset is small, testing a pipeline may take some time to complete, and an unfinished pipeline may unexpectedly use a lot of resources, for example the default pipeline settings may reserve multiple CPUs.  
6. Use a compute node. Even though the command is simple, it may take a long time to complete.  
7. Use a compute node. If you're unsure about the resource requirements of your task, it's safer to use a compute node to avoid unexpected overloading of the login node.  
8. Use a login node. Checking the status of your jobs is a quick task that doesn't require much memory or time, so it's fine to run it on a login node.  

**You are done when:**  

- You can confidently decide when to use a compute node instead of a login node.  

## SLURM basics  

Now that you know when to use a compute node, it's time to learn how to use one. This is where SLURM comes in.  

SLURM is a workload manager that allows you to submit jobs to a compute cluster. It manages the allocation of resources and scheduling of jobs on the compute nodes between different users. It is widely used in high-performance computing (HPC) environments, for example the CeMM cluster and the VBC cluster.  

To submit a job to a compute node via SLURM, you have several options:  

- `sbatch` : Submit a non-interactive job to the queue. This is useful for running tasks that don't require user interaction.  
- `srun` : Start a job interactively. This is useful for testing and debugging your code.  
- `salloc` : Allocate resources on a compute node for a job. For some clusters, you must allocate resources before starting a job interatively. This is not the case on the CeMM cluster, but it is still good to know.  

We will focus on `srun` and `sbatch` in this session. You will get a chance to use both of these commands in the following exercises. First, we will cover the extra information you need to provide to SLURM when submitting a job, which is done using SLURM directives.  

## SLURM directives  

When you submit a job to SLURM, you need to tell it what resources your job will require, so that SLURM can schedule your job appropriately and ensure that it has enough resources to run successfully. This is done using SLURM directives.  
Here are some examples of SLURM directives:  

| Option            | Description                                                                                                                                             | Default                                  | Example                      |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- | ---------------------------- |
| `--job-name`      | Specify a name for your job.                                                                                                                            | Name of the job script                   | `--job-name=genome_analysis` |
| `--time`          | Specify the maximum time your job may run.                                                                                                              | Partition-dependent                      | `--time=02:00:00`            |
| `--mem`           | Specify the maximum amount of memory your job will require per node.                                                                                    | Partition-dependent                      | `--mem=16G`                  |
| `--ntasks`        | Specify the number of tasks your job will require. For simple jobs, this is usually `1`.                                                                | `1`                                      | `--ntasks=1`                 |
| `--cpus-per-task` | Specify the number of CPU cores required by each task.                                                                                                  | `1`                                      | `--cpus-per-task=4`          |
| `--nodes`         | Specify the number of compute nodes your job will require.                                                                                              | `1`                                      | `--nodes=1`                  |
| `--nodelist`      | Specify a node or list of specific compute nodes on which your job will run.                                                                            | Any eligible node selected by Slurm      | `--nodelist=d030`         |
| `--output`        | Specify the file to which the standard output of your job will be written.                                                                              | `slurm-%j.out`, where `%j` is the job ID | `--output=logs/%x-%j.out`    |
| `--error`         | Specify the file to which standard error messages will be written.                                                                                      | Same file as `--output`                  | `--error=logs/%x-%j.err`     |
| `--partition`     | Specify the partition, or queue, to which your job will be submitted.                                                                                   | **No default**                               | `--partition=shortq`            |
| `--qos`           | Specify the Quality of Service for your job. On the CeMM cluster, this is configured to be the same as the partition. On other clusters, it may differ. | **No default**                               | `--qos=shortq`                  |


You can find a full list of SLURM directives in the SLURM documentation: [https://slurm.schedmd.com/sbatch.html#SECTION_DIRECTIVES](https://slurm.schedmd.com/sbatch.html#SECTION_DIRECTIVES).  

## SLURM queues

You will notice that the `--partition` and `--qos` directives are compulsory. This is because the CeMM cluster has multiple queues, or partitions, that are configured to have different resource limits and priorities. You must choose the appropriate queue for your job based on the resources it requires and the expected runtime. Here is a table of the CeMM cluster queues:  

######################################## queue pic ###########################################

On the CeMM cluster, you must specify both `--partition` and `--qos` to choose your queue, and these must be identical.  

Once you have chosen your queue, the default `--time` and `--mem` limits will be set according to the queue's configuration. You can override these defaults by specifying your own values for `--time` and `--mem`, but you cannot exceed the maximum limits of the queue.  

Note: There are user and group limits for numbers of jobs on the CeMM cluster. Each user can run a maximum of 1 interactive job at a time, and each group can run a maximum of XXXXXXX jobs at a time on any one queue.  

## Exercise 2: Using `srun` to start an interactive job

**Goal:** Learn to use the `srun` command to start an interactive job on a compute node.  

Now it's time to put everything together and start running jobs on the compute nodes! In this exercise, you will use the `srun` command to start an interactive job on a compute node. This will allow you to access an interactive terminal, similar to the setup we had at the CCRI (RIP).  

Note: on the CeMM cluster, you cannot run more than one interactive job per user at a time. Interactive jobs are also limited to 12 hours maximum.  

1. Time to see if you were listening in Session 1. Log in to the CeMM cluster.  

If you do not have a CeMM cluster account, navigate to [https://learnslurm.com](https://learnslurm.com) and click "> Launch Trainer".  

Take a minute to notice the prompt in the terminal. It should look something like this:  

```bash
[username@login-node ~]$
```

For the CeMM cluster, the login nodes are `d001` and `d002`. For LearnSlurm, the login node is `login-01`.  


2. Once you have opened a terminal on the CeMM cluster, run the following command to start an interactive job on a compute node:  

```bash
srun --partition=interactiveq --qos=interactiveq --cpus-per-task=1 --mem=1G --time 00:20:00 --pty bash -I
```

If you are using LearnSlurm, the "fake cluster" requires you to allocate resources using `salloc` before starting an interactive job using `srun`. Also, the queue names are different, so we will omit the `--partition` and `--qos` directives, and let LearnSlurm choose the default queue. Therefore, you should run the following commands:  

```bash
salloc --time=00:20:00 --mem=1G --cpus-per-task=1
srun --pty bash I
```

Test yourself: what does each part of the command do?  

- `srun`
- `--partition=interactiveq --qos=interactiveq`
- `--cpus-per-task=1`
- `--mem=1G`
- `--time 00:20:00`
- `--pty bash -I` (we haven't covered this, but have a guess)

Answers:

- `srun` : This is the command to start a job on a compute node.  
- `--partition=interactiveq --qos=interactiveq` : This specifies the queue to which the job will be submitted. In this case, we are using the `interactiveq`, which is designed for interactive jobs.  
- `--cpus-per-task=1` : This specifies that the job will require 1 CPU core.  
- `--mem=1G` : This specifies that the job will require 1 GB of memory.  
- `--time 00:20:00` : This specifies that the job will have a maximum runtime of 20 minutes.  
- `--pty bash -I` : This is a bit unfair since we haven't covered this yet. `--pty` stands for "pseudo-terminal" and is used to allocate a terminal for the job. `bash -I` specifies that the job will start an interactive Bash shell.  

Now that you have submitted your job, once the resources are allocated, you should observe that the node prompt has changed, indicating that you are now on a compute node:  

```bash
[username@compute-node ~]$
```

You can confirm this by running the `hostname` command, which will display the name of the compute node you are currently on. For the CeMM cluster, compute nodes are anything other than `d001` and `d002`. For LearnSlurm, the example compute node is `node004`.  

**You are done when:** 

- You have successfully started an interactive job on a compute node.
- You have confirmed that you are on a compute node using the `hostname` command.

## Exercise 3: Running simple commands and scripts using the command line on a compute node via an interactive job  

**Goal:** Learn to run simple commands and scripts using the command line on a compute node via an interactive job.  

1. Once you are on a compute node, you can run commands just like you would on a login node. To demonstrate this, let's build on some commands from Session 1.  

Navigate into the local copy of this git repository you cloned last time. If you are using LearnSlurm, you can skip this step, and stay in your current working directory.  

```bash
cd /nobackup/<lab_name>/<username>/Introduction_to_Scientific_Computing/session_2/
```

2. Now make and run the `hello_ccri.sh` script again, this time from the terminal of the compute node that you have accessed via your interactive job.

```bash
touch hello_ccri.sh
echo '#!/bin/bash' > hello_ccri.sh
echo 'echo "Hello, CCRI!"' >> hello_ccri.sh
bash hello_ccri.sh
```

You should see the following output:

```bash
Hello, CCRI!
```

You can see that the script runs successfully on the compute node, and that you can use the command line to run commands on a compute node just like you would on a login node. The main difference is that you can now run commands that require more resources, such as more memory or CPU cores, without worrying about overloading the login node. Running an interactive job is the closest you can get to the previous CCRI setup, and is a good way to test your code before submitting it as a batch job.  

3. To exit your interative job, simply type `exit` and press `Enter`. This will return you to the login node. You can confirm this by running the `hostname` command again, which should now display the name of the login node.  

4. What happens when we try to request more resources than are allowed for the queue? Try to request longer than 12 hours on the `interactiveq`. What happens?  

You should see the following error message:

```bash
srun: error: Unable to allocate resources: Requested time limit is invalid (missing or exceeds some limit)
```

Remember to check the queue limits before submitting a job, and make sure to request resources that are within the limits of the queue. You can find the queue limits in the table above.  

**You are done when:**

- You have successfully generated the `hello_ccri.sh` script and run it on a compute node via your interactive job.  
- You have exited your interactive job and returned to the login node.  
- You have tested what happens when you request more resources than are allowed for the queue.  

## Exercise 4: Running a simple `.sbatch` script on a compute node  

**Goal:** Learn to run a simple `.sbatch` script on a compute node.

Now, we will turn your `hello_ccri.sh` script into a SLURM **batch job** script (`.sbatch`), which can be submitted to the queue using the `sbatch` command. This will allow you to run your script on a compute node without needing to be logged in interactively.  

To turn a `.sh` script into a `.sbatch` script, you need to add SLURM directives at the top of the script. The directives are the same as those found in Table 1. In an `srun` commmand, you specify the directives as command line arguments, but in a `.sbatch` script, you specify them as comments at the top of the script. These comments start with `#SBATCH`, and are followed by the directive and its value.  

> [!NOTE]
> Both `.sh` and `.sbatch` scripts are just shell scripts, but `.sbatch` scripts include SLURM directives that tell SLURM what resources your job will require. Technically, you can also submit a `.sh` script to SLURM using `sbatch`, but it is good practice to use the `.sbatch` extension for scripts that are intended to be submitted to SLURM.  

1. First, let's take a look at a example `.sbatch` script with SLURM directives included.

```bash
cat example_job_script.sbatch
```

You should see the following output:

```bash
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
```

You can see that the SLURM directives are included at the top of the script, and that they specify the resources that the job will require. The `#SBATCH` comments are ignored by the shell, but are read by SLURM when the job is submitted.  

2. Next, create a copy of your `hello_ccri.sh` script and name it `hello_ccri.sbatch`.  

```bash
cp hello_ccri.sh hello_ccri.sbatch
```

3. Modify your `hello_ccri.sbatch` script to include SLURM directives. Open the script in a text editor and add SLURM directives to your script, similar to the ones in the example script. You can choose your own values for the directives, but make sure to include at least the following: `--job-name`, `--time`, `--mem`, `--nodes`, `--ntasks`, `--cpus-per-task`, `--partition`, and `--qos`. You can also specify output and error files using the `--output` and `--error` directives.  

If you don't have a text editor installed on the compute node, you can use `nano`, which is a simple text editor that is available on most Linux systems. To open the script in `nano`, run the following command:

```bash
nano hello_ccri.sbatch
```

To save your work in `nano`, press `Ctrl + O`, then press `Enter`. To exit, press `Ctrl + X`.  

4. Now, we will submit the `.sbatch` script to SLURM using the `sbatch` command. This will allow SLURM to schedule your job on a compute node and run it in the background.  

```bash
sbatch hello_ccri.sbatch
```

You should see the output:

```bash
Submitted batch job <job_id>
```

If your job runs straight away, you will see the output files you specified in the `--output` and `--error` SLURM directives in your current working directory. The `--output` file should contain the following line:

```bash
Hello, CCRI!
```

However, if your job does not run straight away, for example if the cluster is very busy, then the output files will not appear yet.  

5. Now what? We just submitted a job into the ether, but we need a way to track its status, to understand what is happening if the job is not running as it should be, and to cancel jobs if necessary. It is also useful to track the general usage of the cluster, such as how many jobs are currently running in each queue, so that you can choose which queue to submit your job in accordingly.  

We will learn to do this in the next section!  


**You are done when:** 

- You have successfully created a `.sbatch` script from your `hello_ccri.sh` script.  
- You have successfully submitted your `.sbatch` script to SLURM using the `sbatch` command.  

## Exercise 5: Useful commands to track cluster usage and job status  

**Goal:** Learn to track cluster usage and job status, and how to cancel jobs if necessary.  

### Tracking general cluster usage - sinfo, squeue  

Before submitting a job, it is a good idea to get an overview of the cluster usage, so you can choose the appropriate queue, or even node, for your job, or get an idea of how soon your job will be run. You can use the following commands to get an overview of the cluster usage.  

| Command | Description |
| ------- | ----------- |
| `sinfo` | Show the "states" of nodes in each queue. |
| `squeue` | Show the status of jobs in the queue. You can use the `--q <queue>` option to show only jobs from a specific queue. |

Try it yourself:

1. Run the `sinfo` command. You should see an output similar to:

```bash
PARTITION    AVAIL  TIMELIMIT  NODES  STATE NODELIST
covid           up 20-00:00:0      2  drain d[015,018]
covid           up 20-00:00:0      3    mix d[016-017,019]
covid           up 20-00:00:0      1  alloc d020
develop         up    1:00:00      1   idle d002
interactiveq    up   12:00:00      3  drain d[014-015,018]
interactiveq    up   12:00:00     14    mix d[010-013,016-017,019,023-029]
interactiveq    up   12:00:00      9  alloc d[003-009,020-021]
interactiveq    up   12:00:00      1   idle d030
longq           up 30-00:00:0      1    mix d010
longq           up 30-00:00:0      7  alloc d[003-009]
mediumq         up 2-00:00:00      3  drain d[014-015,018]
mediumq         up 2-00:00:00      2  alloc d[008-009]
mediumq         up 2-00:00:00      6    mix d[010-013,016-017]
shortq          up   12:00:00      3  drain d[014-015,018]
shortq          up   12:00:00      9    mix d[010-013,016-017,019,025-026]
shortq          up   12:00:00      8  alloc d[003-009,020]
tinyq           up    2:00:00      3  drain d[014-015,018]
tinyq           up    2:00:00      9    mix d[010-013,016-017,019,023-024]
tinyq           up    2:00:00      9  alloc d[003-009,020-021]
gpu             up 3-00:00:00     14    mix d[016-017,019,023-029,032-035]
gpu             up 3-00:00:00      2  alloc d[020-021]
gpu             up 3-00:00:00      2   idle d[030-031]
```

From this output, you can see the partitions, their availability, time limits, number of nodes, state, and node list. The state can be:

- `idle`: The node is available for use. 
- `alloc`: The node is currently allocated to a job.
- `mix`: The node is partially allocated to a job, and partially available for use.
- `drain`: The node is not available for use, and is being drained of jobs. This can happen if the node is being taken offline for maintenance, or if it is experiencing hardware issues.  

This output can be helpful in deciding which queue or nodes to submit your job to, as you may want to avoid queues that have a high number of jobs in the `alloc` state, or nodes that are in the `drain` state.  

2. Run the `squeue` command. You should see an output similar to:

```bash
JOBID    PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
13057525       gpu histopat arendeir  R 2-22:16:09      1 d019
13057526       gpu histopat arendeir  R 2-22:16:09      1 d028
13059870 interacti jupyter-    dmayr  R    3:59:48      1 d021
13059477 interacti rstudio_   shinic  R    5:10:15      1 d003
13059257 interacti     bash cprakash  R    6:54:25      1 d003
13059259 interacti dev_alek   abykov  R    6:46:33      1 d003
13060869     longq nf-check cprakash PD       0:00      1 (Priority)
13060868     longq nf-gunzi cprakash PD       0:00      1 (Resources)
13061037     longq bam_to_f  vellmer  R    1:38:00      1 d010
13060864   mediumq nfcore_p cprakash  R    1:58:17      1 d010
13064062    shortq ascat_32  bpichon PD       0:00      1 (None)
13064061    shortq ascat_32  bpichon PD       0:00      1 (None)
13028443    shortq nfcore_c    ckohl PD       0:00      1 (Dependency)
13064057    shortq ascat_32  bpichon  R       0:40      1 d019
13064052    shortq ascat_32  bpichon  R       1:18      1 d019
13064060    shortq nf-NFCOR    ckohl  R       0:26      1 d025
13064056    shortq nf-NFCOR    ckohl  R       0:45      1 d011
13064055     tinyq nf-NFCOR    ckohl  R       0:48      1 d017
13064040     tinyq nf-NFCOR    ckohl  R       2:26      1 d016
```

Take a look at the `NODELIST(REASON)` column. If a job is running, you can see the name of the compute node that it is running on. If a job is pending, you should see a reason for why it is pending.  

Examples of reasons why a job may be pending include:  

- `Priority` : This means that your job is pending because there are other jobs in the queue with a higher priority.  
- `Resources` : This means that there are not enough resources available on the cluster to run your job.  
- `None` : This usually means the job was just submitted, and the scheduler hasn't had a chance to process it yet.  
- `Dependency` : This means that your job is pending because it is waiting for another job to complete. For example, if you submitted a job that depends on the output of another job, your job will be pending until the other job completes.  
- `AssocGroupLimit` : This means that your job is pending because your group has reached its limit for the number of jobs that can be running at the same time on that queue.  
- `AssocMaxJobsLimit` : This means that your job is pending because you have reached the limit for the number of jobs that you can have running at the same time on that queue, for example if you try to submit a second interactive job while you already have one running.  

> [!NOTE]
> The CeMM cluster operates on a "fair share" basis, which means that the more you use the cluster, the lower your priority will be. This is to ensure that all users have fair access to the cluster resources. This is why it is important to choose the appropriate queue for your job, and to reserve the minimum resources necessary for your job to run successfully. **If you reserve more resources than you need, your job will have a lower priority and may take longer to start running.**


3. Now, try the `squeue --q <queue>` command to show only jobs from a specific queue. For example, to show only jobs from the `tinyq`, run the following command:

```bash
squeue --q tinyq
```

You should observe that the output is filtered to show only jobs from the `tinyq` queue. This can be useful if you want to check the status of your job in a specific queue, or if you want to see how many jobs are currently running in a specific queue.  

### Tracking currently running jobs - squeue, scontrol, seff  

There are several commands that you can use to track the status of your currently running jobs. Here are some of the most useful ones:

| Command | Description |
| ------- | ----------- |
| `squeue --me` | Show the status of your jobs. |
| `scontrol show job <job_id>` | Show detailed information about a specific job, including its status, resources, and output files. |
| `seff <job_id>` | Show the efficiency of a specific job, including its CPU and memory usage. |

Try this for yourself:

1. Edit the `hello_ccri.sbatch` script to include the following lines at the end of the script:

```bash
sleep 300
echo "Job completed after 5 minutes."
```

This will make the job wait for 5 minutes before completing, which will give you time to check its status while it is running. NB make sure that your `--time` SLURM directive is longer than 5 minutes.  

2. Submit the modified `hello_ccri.sbatch` script to SLURM using the `sbatch` command.  

```bash
sbatch hello_ccri.sbatch
```

3. Use the `squeue --me` command to check the status of your job. You should see your job in the queue, with a status of `R` (running) or `PD` (pending).  

```bash
squeue --me
```

Example output:  
```
JOBID       PARTITION   NAME    USER    ST  TIME  NODES NODELIST(REASON)
13063801    tinyq       hello   ccasey  R   1:16  1     d023
```

Here, you can see that the job has been running on node `d023` for 1 minute and 16 seconds. The job ID is `13063801`, which you will need for the next step.

4. Use the `scontrol show job <job_id>` command to show detailed information about your job. You can find the job ID from the output of the `squeue` command.  

```bash
scontrol show job <job_id>
```

Here is an example output:

```bash
JobId=13063801 JobName=hello
   UserId=ccasey(11151) GroupId=lab_ccri_bicu(20800) MCS_label=N/A
   Priority=3648 Nice=0 Account=lab_ccri_bicu QOS=tinyq
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   RunTime=00:00:14 TimeLimit=00:10:00 TimeMin=N/A
   SubmitTime=2026-07-27T16:16:05 EligibleTime=2026-07-27T16:16:05
   AccrueTime=2026-07-27T16:16:05
   StartTime=2026-07-27T16:16:06 EndTime=2026-07-27T16:26:06 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2026-07-27T16:16:06 Scheduler=Main
   Partition=tinyq AllocNode:Sid=d001:1694680
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=d023
   BatchHost=d023
   NumNodes=1 NumCPUs=1 NumTasks=1 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=1,mem=1G,node=1,billing=1
   AllocTRES=cpu=1,mem=1G,node=1,billing=1
   Socks/Node=* NtasksPerN:B:S:C=0:0:*:* CoreSpec=*
   MinCPUsNode=1 MinMemoryNode=1G MinTmpDiskNode=0
   Features=(null) DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/path/to/Introduction_to_Scientific_Computing/session_2/hello_ccri.sbatch
   WorkDir=/path/to/Introduction_to_Scientific_Computing/session_2
   StdErr=/path/to/Introduction_to_Scientific_Computing/session_2/hello_13063801.err
   StdIn=/dev/null
   StdOut=/path/to/Introduction_to_Scientific_Computing/session_2/hello_13063801.out
   TresPerTask=cpu=1
```

Test yourself:  

- What resources were requested for this job?  
- What is the current state of the job?  
- What partition is the job running in?
- What is the name of the compute node that the job is running on?
- What is the path to the output file for this job?

Answers:

- The resources requested for this job were 1 CPU core, 1 GB of memory, and 1 node.  
- The current state of the job is `RUNNING`.  
- The job is running in the `tinyq` partition.  
- The job is running on compute node `d023`.  
- The path to the output file for this job is `/path/to/Introduction_to_Scientific_Computing/session_2/hello_13063801.out`.  

> [!TIP]
> You can also use `scontrol` to update the resources requested by a job on the fly. For example, try `scontrol update JobId=<job_id> timelimit=00:05:00` to decrease the time limit of your job to 5 minutes. This can come in handy if your job is `PENDING` due to requesting too may resources. However, increasing resources is not always allowed, and you cannot increase the number of CPUs or nodes requested for a job that is already running.  

5. Use the `seff <job_id>` command to show the efficiency of your job. This will show you how much CPU and memory your job used, and how much was allocated to it.  

```bash
seff <job_id>
```

Here is an example output:  

```bash
Job ID: 13063801
Cluster: slurm
User/Group: ccasey/lab_ccri_bicu
State: RUNNING
Cores: 1
CPU Utilized: 00:00:00
CPU Efficiency: 0.00% of 00:01:41 core-walltime
Job Wall-clock time: 00:01:41
Memory Utilized: 0.00 MB (estimated maximum)
Memory Efficiency: 0.00% of 1.00 GB (1.00 GB/node)
WARNING: Efficiency statistics may be misleading for RUNNING jobs.
```

This output is useful to track the effiency of the job i.e. how much of the reserved resources the job actually used. However, for running jobs, the efficiency statistics may be misleading, as the job has not yet completed and may still be using resources.  

### Tracking completed jobs - seff, sacct  

1. The `seff` command can also be used to display information about completed jobs (within the last 30 days). Once your job has finished, use the `seff` command to display updated information about the job, including its CPU and memory usage, and its efficiency.  

```bash
seff <job_id>
```

Here is an example output:

```bash
Job ID: 13063801
Cluster: slurm
User/Group: ccasey/lab_ccri_bicu
State: COMPLETED (exit code 0)
Cores: 1
CPU Utilized: 00:00:00
CPU Efficiency: 0.00% of 00:05:00 core-walltime
Job Wall-clock time: 00:05:00
Memory Utilized: 676.00 KB
Memory Efficiency: 0.06% of 1.00 GB
```

Test yourself:

- What is the final state of the job?
- What was the total wall-clock time for the job?
- What was the total CPU time used by the job?
- What was the total memory used by the job?
- How is the efficiency of the job calculated?

Answers:

- The final state of the job is `COMPLETED` with an exit code of `0`, which indicates that the job completed successfully.
- The total wall-clock time for the job was 5 minutes.
- The total CPU time used by the job was 0 seconds (rounded down).
- The total memory used by the job was 676 KB.
- The efficiency of the job is calculated as the ratio of the resources used by the job to the resources that were allocated to it. In this case, the CPU efficiency is 0.00% because the job did not use any CPU time, and the memory efficiency is 0.06% because the job used only a small fraction of the allocated memory.  

From this output, you can see that the effiency was very low, suggesting that fewer resources should be requested for this job in the future. It is a good idea to check the efficiency of your jobs after they have completed, and to adjust your resource requests accordingly for future jobs.  

2. If you want to see information about multiple jobs at a time, you can use the `sacct` command.  

```bash
sacct
```

Here is an example output:  

```bash
JobID           JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
13060402           bash interacti+ lab_ccri_+          1    TIMEOUT      0:0 
13060402.ex+     extern            lab_ccri_+          1  COMPLETED      0:0 
13060402.0         bash            lab_ccri_+          1  COMPLETED      0:0 
13063801          hello      tinyq lab_ccri_+          1  COMPLETED      0:0 
13063801.ba+      batch            lab_ccri_+          1  COMPLETED      0:0 
13063801.ex+     extern            lab_ccri_+          1  COMPLETED      0:0 
```

This output shows the job ID, job name, partition, account, allocated CPUs, state, and exit code for each job. You can see that the `hello` job has completed successfully with an exit code of `0`. The `interactive` job has timed out, which means that it exceeded the time limit that was set for it. 

States that you may see for jobs include:

- `COMPLETED`: The job completed successfully.  
- `FAILED`: The job failed to complete successfully.  
- `CANCELLED`: The job was cancelled by the user or by the system.  
- `TIMEOUT`: The job exceeded the time limit that was set for it.  

### Cancelling jobs - scancel

If you need to cancel a job that is currently running or pending, you can use the `scancel` command. You will need the job ID of the job you want to cancel, which you can find using the `squeue` or `sacct` commands.  

1. Submit a new job using the `hello_ccri.sbatch` script, and note the job ID that is returned.  

```bash
sbatch hello_ccri.sbatch
# Submitted batch job 13064631
```

2. Run the `squeue --me` command to check the status of your jobs. You should see your new job in the queue, with a status of `R` (running) or `PD` (pending).  

```bash
squeue --me
```

```bash
JOBID       PARTITION   NAME    USER    ST      TIME  NODES NODELIST(REASON)
13064631    tinyq       hello   ccasey  R       0:23      1 d016
```

3. Use the `scancel` command to cancel the job. Replace `<job_id>` with the job ID of the job you want to cancel.  

```bash
scancel <job_id>
```

4. Now, run the `squeue --me` command again to check the status of your jobs.  

```bash
squeue --me
```

You should see that the job you cancelled is no longer in the queue.  

5. You can also use the `sacct` command to check the status of the cancelled job.  

```bash
sacct
```

```bash
JobID           JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
13060402           bash interacti+ lab_ccri_+          1    TIMEOUT      0:0 
13060402.ex+     extern            lab_ccri_+          1  COMPLETED      0:0 
13060402.0         bash            lab_ccri_+          1  COMPLETED      0:0 
13063801          hello      tinyq lab_ccri_+          1  COMPLETED      0:0 
13063801.ba+      batch            lab_ccri_+          1  COMPLETED      0:0 
13063801.ex+     extern            lab_ccri_+          1  COMPLETED      0:0 
13064631          hello      tinyq lab_ccri_+          1 CANCELLED+      0:0 
13064631.ba+      batch            lab_ccri_+          1  CANCELLED     0:15  ***
13064631.ex+     extern            lab_ccri_+          1  COMPLETED      0:0 
```

For example, you can see the job with ID `13064631` has a state of `CANCELLED`, which means that it was successfully cancelled.  

6. Check the `--error` output file for the cancelled job. You should see something similar to this, which shows that the job was cancelled and at what time.  

```bash
slurmstepd: error: *** JOB 13064631 ON d016 CANCELLED AT 2026-07-27T17:20:36 ***
```

> [!TIP]
> To cancel all of your jobs running on a specific queue, you can use the `scancel $(sq -q tinyq -h -o %i)` command, which will cancel all jobs in the `tinyq` queue. You can replace `tinyq` with the name of any other queue to cancel all jobs in that queue.  


### Cheatsheet of useful commands

| Command | Description |
| ------- | ----------- |
| `sinfo` | Show the "states" of nodes in each queue. |
| `squeue` | Show the status of jobs in the queue. You can use the `--q <queue>` option to show only jobs from a specific queue, or the `--me` option to show only your jobs. |
| `scontrol show job <job_id>` | Show detailed information about a specific job, including its status, resources, and output files. |
| `scontrol update JobID=<jobid> timelimit=<new_time>` | Change the time limit of a specific job. |
| `seff <job_id>` | Show the efficiency of a specific job, including its CPU and memory usage. |
| `sacct` | Show information about completed jobs, including their status, resources, and exit codes. |
| `scancel <job_id>` | Cancel a job that is currently running or pending. |

**You are done when:**

- You have successfully tracked the general usage of the cluster using the `sinfo` and `squeue` commands.  
- You have successfully tracked the status of your jobs using the `squeue --me`, `scontrol`, `sacct`, and `seff` commands.  
- You have successfully cancelled a job using the `scancel` command.  

## End of Session 2

Yay, you have made it to the end of Session 2! You should now have a good understanding of how to submit jobs to SLURM, track their status, and cancel them if necessary. You should also have a good understanding of the different queues on the CeMM cluster, and how to choose the appropriate queue for your job based on its resource requirements and expected runtime. See you in Session 3 to run some real bioinformatics pipelines on the CeMM cluster!  