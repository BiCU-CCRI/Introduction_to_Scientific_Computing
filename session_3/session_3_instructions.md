# Introduction to Scientific Computing - Session 3  

Welcome to Session 3 of the Introduction to Scientific Computing course! Glad to see you enjoyed Sessions 1 & 2 enough to come back for more. 

So far, we have been running commands from the terminal of your local machine. This means you are limited to the resources available on your laptop, which is usually around 4-16 GB of RAM and 2-8 CPU cores. This is fine for small tasks, but if you want to run more complex or resource-intensive tasks, you will need to use a compute node on a scientific computing cluster. For example, mapping reads from a human sample to the reference genome often requires around 32 GB of RAM, and training a machine learning model often requires GPUs and multiple CPU cores. These tasks are not feasible on a laptop, but they can be run on a scientific computing cluster.  

Since scientific computing is therefore often done on a cluster, it is important to know how to run tasks on one. Today we will learn about how to submit jobs on a scientific computing cluster using a workload manager called SLURM.  

## Overview
  
Today we'll cover:  

1. Exercise 1: Learning when to use a compute node instead of a login node  
2. SLURM basics  
3. SLURM directives  
4. SLURM queues  
5. Exercise 2: Using `srun` to start an interactive job  
6. Exercise 3: Running simple commands and scripts using the command line on a compute node via an interactive job  
7. Exercise 4: Submitting a simple `.sbatch` script to a compute node  
8. Exercise 5: Useful commands to track cluster usage and job status  

### Codespaces setup  

>[!IMPORTANT]
>For session 3, we need to run CodeSpaces from a different branch of the repository to launch an environment which simulates SLURM. Please pay attention to the instructions below.  

We will use Codespaces to the login node of a computing cluster. You can use Codespaces to practice running simple commands and scripts on a pretend cluster without needing a CeMM account. Please review the main [README.md - A guide to GitHub Codespaces](../README.md#a-guide-to-github-codespaces) for a detailed overview of Codespaces.  

1. Navigate to the [`session_3`](https://github.com/BiCU-CCRI/Introduction_to_Scientific_Computing/tree/session_3) branch.

2. Click on the green "Code" button.

3. Select the "Codespaces" tab.

4. Click on the "Create codespace on session_3" button.  

5. Wait for the environment to build - this can take 5-10 minutes the first time.  

## Exercise 1: Learning when to use a compute node instead of a login node

**Goal:** Learn to decide when to use a compute node instead of a login node.  

Computing clusters are a collection of computers, or nodes, that are connected together to form a single system. Each node has its own CPU cores and memory, and can be used to run tasks in parallel.  

When you log onto a computing cluster, you are usually logged onto a **login node**. The login node is a shared resource that is used to submit jobs to the cluster, and to run simple commands and scripts. If you want to run more complex or resource-intensive tasks, you will need to use a **compute node**.  

Login nodes have limited resources, and running resource-intensive tasks on them can slow down the system for everyone. Compute nodes, on the other hand, are designed to handle more demanding workloads.  

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

<details>

<summary>Answers</summary>

1. Use a login node. This is a quick and simple task that doesn't require much memory or time.  
2. Use a compute node. This task is resource-intensive and will take a long time to complete, so it's best to run it on a compute node.  
3. Either. Generating a small plot is a quick task that doesn't require much memory or time, so it's fine to run it on a login node.  
4. Use a compute node. Even though generating a plot may seem like a simple task, if the dataset is large, loading the data into memory may take a long time and use a lot of memory.  
5. Use a compute node. Even though the dataset is small, testing a pipeline may take some time to complete, and an unfinished pipeline may unexpectedly use a lot of resources, for example the default pipeline settings may reserve multiple CPUs.  
6. Use a compute node. Even though the command is simple, it may take a long time to complete.  
7. Use a compute node. If you're unsure about the resource requirements of your task, it's safer to use a compute node to avoid unexpected overloading of the login node.  
8. Use a login node. Checking the status of your jobs is a quick task that doesn't require much memory or time, so it's fine to run it on a login node.  
</details>

**You are done when:**  

- You can confidently decide when to use a compute node instead of a login node.  

## 2. SLURM basics  

Now that you know when to use a compute node, it's time to learn how to use one. This is where SLURM comes in.  

SLURM is a workload manager that allows you to submit jobs to a compute cluster. It manages the allocation of resources and scheduling of jobs on the compute nodes between different users. It is widely used in high-performance computing (HPC) environments, for example the CeMM cluster and the VBC cluster.  

To submit a job to a compute node via SLURM, you have several options:  

- `sbatch` : Submit a non-interactive job to the queue. This is useful for running tasks that don't require user interaction.  
- `srun` : Start a job interactively. This is useful for testing and debugging your code.  
- `salloc` : Allocate resources on a compute node for a job. For some clusters, you must allocate resources before starting a job interatively. This is not the case on the CeMM cluster, but it is still good to know.  

We will focus on `srun` and `sbatch` in this session. You will get a chance to use both of these commands in the following exercises. First, we will cover the extra information you need to provide to SLURM when submitting a job, which is done using SLURM directives.  

## 3. SLURM directives  

When you submit a job to SLURM, you need to tell it what resources your job will require, so that SLURM can schedule your job appropriately and ensure that it has enough resources to run successfully. This is done using SLURM directives.  
Here are some examples of SLURM directives:  

| Option            | Description                                                                                                                                             | Default                                  | Example                      |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- | ---------------------------- |
| `--job-name`      | Specify a name for your job.                                                                                                                            | Name of the job script                   | `--job-name=ngs_analysis` |
| `--time`          | Specify the maximum time your job may run.                                                                                                              | Partition-dependent                      | `--time=02:00:00`            |
| `--mem`           | Specify the maximum amount of memory your job will require per node.                                                                                    | Partition-dependent                      | `--mem=16G`                  |
| `--ntasks`        | Specify the number of tasks your job will require. For simple jobs, this is usually `1`.                                                                | `1`                                      | `--ntasks=1`                 |
| `--cpus-per-task` | Specify the number of CPU cores required by each task.                                                                                                  | `1`                                      | `--cpus-per-task=4`          |
| `--nodes`         | Specify the number of compute nodes your job will require.                                                                                              | `1`                                      | `--nodes=1`                  |
| `--nodelist`      | Specify a node or list of specific compute nodes on which your job will run.                                                                            | Any eligible node selected by Slurm      | `--nodelist=d030`         |
| `--output`        | Specify the file to which the standard output of your job will be written.                                                                              | `slurm-%j.out`, where `%j` is the job ID | `--output=logs/%x-%j.out`    |
| `--error`         | Specify the file to which standard error messages will be written.                                                                                      | Same file as `--output`                  | `--error=logs/%x-%j.err`     |
| `--partition`     | Specify the partition, or queue, to which your job will be submitted.                                                                                   | **CeMM cluster: No default**                               | `--partition=shortq`            |
| `--qos`           | Specify the Quality of Service for your job. On the CeMM cluster, this is configured to be the same as the partition. On other clusters, it may differ. | **CeMM cluster: No default**                               | `--qos=shortq`                  |


You can find a full list of SLURM directives in the SLURM documentation: [https://slurm.schedmd.com/sbatch.html#SECTION_DIRECTIVES](https://slurm.schedmd.com/sbatch.html#SECTION_DIRECTIVES).  

## 4. SLURM queues

You will notice that for the CeMM cluster, the `--partition` and `--qos` directives are compulsory. Clusters using SLURM have multiple queues, or partitions, that are configured to have different resource limits and priorities. You must choose the appropriate queue for your job based on the resources it requires and the expected runtime. Here is a table of the CeMM cluster queues - note the user and group limits for each queue:  

<img width="715" height="471" alt="job_queues" src="https://github.com/user-attachments/assets/9e013c14-ef3e-4f16-b35a-8e98cbe54ac2" />

  
>[!NOTE]
>On the CeMM cluster, you must specify both `--partition` and `--qos` to choose your queue, and these must be identical. With LearnSlurm, it is sufficient to only specify `--partition`.  

Once you have chosen your queue, the default `--time` and `--mem` limits will be set according to the queue's configuration. You can override these defaults by specifying your own values for `--time` and `--mem`, but you cannot exceed the maximum limits of the queue.  

## 5. Exercise 2: Using `srun` to start an interactive job

**Goal:** Learn to use the `srun` command to start an interactive job on a compute node.  

Now it's time to put everything together and start running jobs on the compute nodes! In this exercise, you will use the `srun` command to start an interactive job on a compute node. This will allow you to access an interactive terminal, similar to the setup we had at the CCRI (RIP).  

>[!NOTE]
>On the CeMM cluster, you cannot run more than one interactive job per user at a time. Interactive jobs are also limited to 12 hours maximum.  

1. Open your CodeSpaces.  

Take a minute to notice the prompt in the terminal. It should look like this:  

```bash
[codespace@login-01 Introduction_to_Scientific_Computing]$ 
```

From the prompt, you can see that you are on a login node `login-01`. You can confirm this by running the `hostname` command, which will display the name of the node you are currently on.  

2. Start an interactive session using the following commands:  

```bash
srun --partition=interactiveq --qos=interactiveq --time 00:20:00 --mem=1G --cpus-per-task=1 --pty bash
```

Test yourself: what does each part of the command do?  

- `srun`
- `--partition=interactiveq --qos=interactiveq` 
- `--time 00:20:00`
- `--mem=1G`
- `--cpus-per-task=1`
- `--pty bash` (we haven't covered this, but have a guess)

<details>

<summary>Answers</summary>

- `srun` : This is the command to start a job on a compute node.  
- `--partition=interactiveq --qos=interactiveq` : This specifies that the job will be submitted to the `interactiveq` queue, which is configured for interactive jobs.  
- `--time 00:20:00` : This specifies that the job will have a maximum runtime of 20 minutes.  
- `--mem=1G` : This specifies that the job will require 1 GB of memory.  
- `--cpus-per-task=1` : This specifies that the job will require 1 CPU core.  
- `--pty bash` : This is a bit unfair since we haven't covered this yet. `--pty` stands for "pseudo-terminal" and is used to allocate a terminal for the job. `bash` specifies that the job will start an interactive Bash shell.  
</details>

Now that you have submitted your job, once the resources are allocated, you should observe that the node prompt has changed, indicating that you are now on a compute node:  

```bash
user@node004:~$ 
```

From this prompt, you can see that you are on compute node `node004`. You can confirm this by running the `hostname` command, which will display the name of the compute node you are currently on.  

**You are done when:** 

- You have successfully started an interactive job on a compute node.
- You have confirmed that you are on a compute node using the `hostname` command.

## Exercise 3: Running simple commands and scripts using the command line on a compute node via an interactive job  

**Goal:** Learn to run simple commands and scripts using the command line on a compute node via an interactive job.  

1. Once you are on a compute node, you can run commands just like you would on a login node. To demonstrate this, let's run some simple commands.  

Try the following:

- Run the `ls` command to list the files in your current directory.  
- Run the `pwd` command to print the current working directory.  
- Run the `echo` command to print a message to the terminal, for example: `echo "Hello, CCRI!"`.  

You can see that you can use the command line to run commands or scripts on a compute node just like you would on a login node. The main difference is that you can now run commands that require more resources, such as more memory or CPU cores, without worrying about overloading the login node. Running an interactive job is the closest you can get to the previous CCRI setup, and is a good way to test your code before submitting it as a batch job.  

3. To exit your interative job, simply type `exit` and press `Enter`. This will return you to the login node. You can confirm this by running the `hostname` command again, which should now display the name of the login node.  

4. Let's try to request more resources than are available/allowed. Try to request 50G on the interactive queue:

```bash
srun --partition=interactiveq --qos=interactiveq --time 00:20:00 --mem=50G --cpus-per-task=1 --pty bash
```

You should get the following error:  

```bash
srun: error: Memory specification can not be satisfied
srun: error: Unable to allocate resources: Requested node configuration is not available
```

>[!IMPORTANT]
>Remember to check the queue limits before submitting a job, and make sure to request resources that are within the limits of the queue.  

**You are done when:**

- You have successfully run simple commands on a compute node via an interactive job.
- You have exited your interactive job and returned to the login node.  
- You have submitted a job that requests more resources than are available/allowed, and observed the error message.  

## Exercise 4: Submitting a simple `.sbatch` script to a compute node  

**Goal:** Learn to run a simple `.sbatch` script on a compute node.

Now, we will submit a SLURM **batch job** script to the queue using the `sbatch` command. This will allow you to run your script on a compute node without needing to be logged in interactively.  

To turn a `.sh` script into a batch job script, you need to add SLURM directives at the top of the script. The directives are the same as those found in Table 1. In an `srun` commmand, you specify the directives as command line arguments, but in a batch job script, you specify them as comments at the top of the script. These comments start with `#SBATCH`, and are followed by the directive and its value.  

>[!NOTE]
>Both `.sh` and `.sbatch` scripts are just shell scripts, but `.sbatch` scripts include SLURM directives that tell SLURM what resources your job will require. You can also submit a `.sh` script to SLURM using `sbatch`, but it is good practice to use the `.sbatch` extension for scripts that are intended to be submitted to SLURM. The LearnSlurm batch job scripts are named iwth the `.sh` extension, but you can rename them to `.sbatch` if you want to.  

1. First, let's take a look at an example batch job script with SLURM directives included. Take a look at the `session_3/example_job_script.sbatch` sript provided in the repository.  

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

2. Next, create a file in `session_3` named `hello_ccri.sbatch` using the File Explorer.  

3. Add the following lines to the script:

```bash
#!/bin/bash
echo "Hello, CCRI!"
echo "Waiting for 30 seconds..."
sleep 30
echo "Job finished after 30 seconds."
```  

>[!TIP]
>Use `Ctrl + S` (Windows) or `Cmd + S` (Mac) to save your changes to the script.  

4. Modify your `hello_ccri.sbatch` script to include SLURM directives, similar to the ones in the example script. You can choose your own values for the directives, but make sure to include at least the following: `--job-name`, `--time`, `--mem`, `--nodes`, `--ntasks`, `--cpus-per-task`, and `--partition`. You can also specify output and error files using the `--output` and `--error` directives, however these will not be generated in the LearnSlurm simulation.  

<details>

<summary>Here is a template you can copy and paste into your `hello_ccri.sbatch` script:</summary>

```bash
#!/bin/bash
#SBATCH --job-name=
#SBATCH --time=
#SBATCH --mem=
#SBATCH --nodes=
#SBATCH --ntasks=
#SBATCH --cpus-per-task=
#SBATCH --partition=
#SBATCH --qos=
#SBATCH --output=
#SBATCH --error=
```
</details>

>[!TIP]
>`--ntasks` controls how many separate processes Slurm launches, not how many CPUs you get — for most everyday scripts and tools, keep `--ntasks=1` and use `--cpus-per-task` instead. If you set `--ntasks=2` on a program that isn't designed for it, Slurm/srun would just launch two independent copies of the same script simultaneously, each unaware of the other.
 
5. Now, we will submit the `.sbatch` script to SLURM using the `sbatch` command. This will allow SLURM to schedule your job on a compute node and run it in the background.  

```bash
cd session_3/
sbatch hello_ccri.sbatch
```

You should see the output:

```bash
Submitted batch job <job-id>
```

Congratulations! You have successfully submitted your first batch job to SLURM. After a minute or so you should see the `--output` file you specified in your `.sbatch` script. Check that this contains the following lines:

```bash
Hello, CCRI!
Waiting for 30 seconds...
Job finished after 30 seconds.
```

And hopefully, the `--error` file you specified in your `.sbatch` script should be empty, since there were no errors in your job (we hope).

Now what? We just submitted a job into the ether, but we need a way to track its status, to understand what is happening if the job is not running as it should be, and to cancel jobs if necessary. It is also useful to track the general usage of the cluster, such as how many jobs are currently running in each queue, so that you can choose which queue to submit your job in accordingly.  

We will learn to do this in the next section!  


**You are done when:** 

- You have successfully created the `hello_ccri.sbatch` script.  
- You have successfully submitted your `hello_ccri.sbatch` script to SLURM using the `sbatch` command.  
- You have checked the output and error files generated by your job, and confirmed that the output is as expected.  

## Exercise 5: Useful commands to track cluster usage and job status  

**Goal:** Learn to track cluster usage and job status, and how to cancel jobs if necessary.  

### Tracking general cluster usage - sinfo, squeue  

Before submitting a job, it is a good idea to get an overview of the cluster usage, so you can choose the appropriate queue, or even node, for your job, or get an idea of how soon your job will be run. You can use the following commands to get an overview of the cluster usage.  

| Command | Description |
| ------- | ----------- |
| `sinfo` | Show the "states" of nodes in each queue. |
| `squeue` | Show the status of jobs in the queue. You can use the `-p <partition>` option to show only jobs from a specific partition. |

Try it yourself:

1. Run the `sinfo` command. You should see an output similar to:

```bash
PARTITION    AVAIL  TIMELIMIT  NODES  STATE NODELIST
tinyq           up    2:00:00      2   plnd node[001,004]
tinyq           up    2:00:00      2  alloc node[002-003]
interactiveq    up   12:00:00      2   plnd node[001,004]
interactiveq    up   12:00:00      2  alloc node[002-003]
develop         up    1:00:00      2   plnd node[001,004]
develop         up    1:00:00      2  alloc node[002-003]
shortq          up   12:00:00      2   plnd node[001,004]
shortq          up   12:00:00      2  alloc node[002-003]
mediumq         up 2-00:00:00      2   plnd node[001,004]
mediumq         up 2-00:00:00      2  alloc node[002-003]
longq           up 30-00:00:0      2   plnd node[001,004]
longq           up 30-00:00:0      2  alloc node[002-003]
covid           up 20-00:00:0      2   plnd node[001,004]
covid           up 20-00:00:0      2  alloc node[002-003]
gpu             up 3-00:00:00      0    n/a 
```

From this output, you can see the partitions, their availability, time limits, number of nodes, state, and node list. The state can be:

- `idle`: The node is available for use. 
- `alloc`: The node is currently allocated to a job.
- `mix`: The node is partially allocated to a job, and partially available for use.
- `plnd`: The node is planned for use, but is not currently allocated to a job. This can happen if the node is being taken offline for maintenance, or if it is experiencing hardware issues.  
- `drain`: The node is not available for use, and is being drained of jobs. This can happen if the node is being taken offline for maintenance, or if it is experiencing hardware issues.  
- `down`: The node is not available for use, and is down. This can happen if the node is experiencing hardware issues, or if it has been taken offline for maintenance.  
- `n/a`: The node is not available for use, and is not in a state that can be used. This can happen if the node is experiencing hardware issues, or if it has been taken offline for maintenance.  

This output can be helpful in deciding which queue or nodes to submit your job to, as you may want to avoid queues that have a high number of jobs in the `alloc` state, or nodes that are in the `drain` or `down` states.  

2. Run the `squeue` command. You should see an output similar to:

```bash
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
   3     longq  bigmem_j    alice PD       0:00      4 (Resources)
   4   mediumq  openfoam    alice PD       0:00      1 (Nodes required for job are DOWN, DRAINED or reserved for jobs in higher priority partitions)
   5   mediumq  postproc     dave PD       0:00      1 (Dependency)
   1   mediumq  openfoam    alice  R      15:28      1 node002
   2    shortq  gromacs_      bob  R      15:20      1 node003
```

Take a look at the `NODELIST(REASON)` column. If a job is running, you can see the name of the compute node(s) that it is running on. If a job is pending, you should see a reason for why it is pending.  

Examples of reasons why a job may be pending include:  

- `Priority` : This means that your job is pending because there are other jobs in the queue with a higher priority.  
- `Resources` : This means that there are not enough resources available on the cluster to run your job.  
- `None` : This usually means the job was just submitted, and the scheduler hasn't had a chance to process it yet.  
- `Dependency` : This means that your job is pending because it is waiting for another job to complete. For example, if you submitted a job that depends on the output of another job, your job will be pending until the other job completes.  
- `QOSGrpJobsLimit` : This means that your job is pending because your group has reached its limit for the number of jobs that can be running at the same time on that queue.  
- `ReqNodeNotAvail` : This means that your job is pending because the node(s) that you requested are not available. For example, if you requested a specific node that is currently down or in maintenance, your job will be pending until that node becomes available.  
- `(Nodes required for job are DOWN, DRAINED or reserved for jobs in higher priority partitions)` : What it says on the tin.

>[!NOTE]
>The CeMM cluster operates on a "fair share" basis, which means that the more you use the cluster, the lower your priority will be. This is to ensure that all users have fair access to the cluster resources. This is why it is important to choose the appropriate queue for your job, and to reserve the minimum resources necessary for your job to run successfully. **If you reserve more resources than you need, your job will have a lower priority and may take longer to start running.**

3. Now, try the `squeue -p <queue>` command to show only jobs from a specific partition. For example, to show only jobs from the `shortq` partition, run the following command:

```bash
squeue -p shortq
```

You should observe that the output is filtered to show only jobs from the `shortq` queue. This can be useful if you want to check the status of your job in a specific queue, or if you want to see how many jobs are currently running in a specific queue.  

### Tracking currently running jobs - squeue, scontrol

There are several commands that you can use to track the status of your currently running jobs. Here are some of the most useful ones:

| Command | Description |
| ------- | ----------- |
| `squeue --me` | Show the status of your jobs. |
| `scontrol show job <job_id>` | Show detailed information about a specific job, including its status, resources, and output files. |

Try this for yourself:

1. Start another interactive job using the `srun` command. You can use the same *valid* resource requests as before.  

2. Use the `squeue --me` command to check the status of your job. You should see your job in the queue, with a status of `R` (running) or `PD` (pending).  

```bash
squeue --me
```

Example output:  
```
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
10    interacti     bash codespac  R       0:26      1 node004
```

Here, you can see that the interactive job has been running on node `node004` for 26 seconds. The job ID is `10`, which you will need for the next step.

4. Use the `scontrol show job <job_id>` command to show detailed information about your job. You can find the job ID from the output of the `squeue` command.  

```bash
scontrol show job <job_id>
```

Here is an example output:

```bash
JobId=10 JobName=bash
   UserId=codespace(2000) GroupId=codespace(2000) MCS_label=N/A
   Priority=1 Nice=0 Account=users QOS=interactiveq
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=0 Reboot=0 ExitCode=0:0
   RunTime=00:00:19 TimeLimit=00:20:00 TimeMin=N/A
   SubmitTime=2026-08-06T11:56:39 EligibleTime=2026-08-06T11:56:39
   AccrueTime=2026-08-06T11:56:39
   StartTime=2026-08-06T11:56:59 EndTime=2026-08-06T12:16:59 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2026-08-06T11:56:59 Scheduler=Backfill
   Partition=interactiveq AllocNode:Sid=login-01:2046
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=node004
   BatchHost=node004
   NumNodes=1 NumCPUs=2 NumTasks=1 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=1,mem=1G,node=1,billing=1
   AllocTRES=cpu=2,mem=1G,node=1,billing=2
   Socks/Node=* NtasksPerN:B:S:C=0:0:*:* CoreSpec=*
   MinCPUsNode=1 MinMemoryNode=1G MinTmpDiskNode=0
   Features=(null) DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) LicensesAlloc=(null) Network=(null)
   Command=bash
   SubmitLine=srun --partition=interactiveq --qos=interactiveq --time 00:20:00 --mem=1G --cpus-per-task=1 --pty bash
   WorkDir=/workspaces/Introduction_to_Scientific_Computing
   TresPerTask=cpu=1
```

Test yourself:  

- What resources were requested for this job?  
- What is the current state of the job?  
- What partition is the job running in?
- What is the name of the compute node that the job is running on?

<details>

<summary>Answers:</summary>

- The resources requested for this job were 1 CPU core, 1 GB of memory, and 1 compute node.
- The current state of the job is `RUNNING`.
- The job is running in the `interactiveq` partition. 
- The job is running on compute node `node004`.  
</details>

>[!TIP]
>You can also use `scontrol` to update the resources requested by a job on the fly. For example, try `scontrol update JobId=<job_id> timelimit=00:05:00` to decrease the time limit of your job to 5 minutes. This can come in handy if your job is `PENDING` due to requesting too may resources. However, increasing resources is not always allowed, and you cannot increase the number of CPUs or nodes requested for a job that is already running. 
  
### Tracking completed jobs - sacct, seff 

1. If you want to see information about the last jobs you ran, you can use the `sacct` command.  

```bash
sacct
```

Here is an example output:  

```bash
JobID           JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
6                  bash interacti+      users          0 CANCELLED+      0:0 
7                  bash interacti+      users          2  COMPLETED      0:0 
7.0                bash                 users          2  COMPLETED      0:0 
8                  bash interacti+      users          0 CANCELLED+      0:0 
9                  bash interacti+      users          0     FAILED      1:0 
10                 bash interacti+      users          2    RUNNING      0:0 
10.0               bash                 users          2    RUNNING      0:0 
11           example_j+      tinyq      users          2  COMPLETED      0:0 
11.batch          batch                 users          2  COMPLETED      0:0 
12           example_j+      tinyq      users          2  COMPLETED      0:0 
12.batch          batch                 users          2  COMPLETED      0:0 
13           example_j+      tinyq      users          2  COMPLETED      0:0 
13.batch          batch                 users          2  COMPLETED      0:0 
14           hello_ccri      tinyq      users          2    RUNNING      0:0 
14.batch          batch                 users          2    RUNNING      0:0         
```

This output shows the job ID, job name, partition, account, allocated CPUs, state, and exit code for each job.  

States that you may see for jobs include:

- `RUNNING`: The job is currently running.
- `COMPLETED`: The job completed successfully.  
- `FAILED`: The job failed to complete successfully.  
- `CANCELLED`: The job was cancelled by the user or by the system.  
- `TIMEOUT`: The job exceeded the time limit that was set for it.  

2. The `seff` command can be used to display information about completed jobs (within the last 30 days). 

Use the `sacct` command to find the jobid of your `hello_ccri.sbatch` job, then use the `seff` command to display updated information about the job, including its CPU and memory usage, and its efficiency. 

```bash
seff <job_id>
```

Here is an example output:

```bash
Job ID: 14
Cluster: linux
User/Group: codespace/codespace
State: COMPLETED (exit code 0)
Nodes: 1
Cores per node: 2
CPU Utilized: 00:00:00
CPU Efficiency: 0.00% of 00:01:00 core-walltime
Job Wall-clock time: 00:00:30
Memory Utilized: 0.00 MB
Memory Efficiency: 0.00% of 1.00 GB (1.00 GB/node)
```

Test yourself:

- What is the final state of the job?
- What was the total wall-clock time for the job?
- What was the total CPU time used by the job?
- What was the total memory used by the job?
- How is the efficiency of the job calculated?

<details>

<summary>Answers:</summary>

- The final state of the job is `COMPLETED` with an exit code of `0`, which indicates that the job completed successfully.
- The total wall-clock time for the job was 30 seconds.
- The total CPU time used by the job was 0 seconds (rounded down).
- The total memory used by the job was 0 MB (rounded down).
- The efficiency of the job is calculated as the ratio of the resources used by the job to the resources that were allocated to it. In this case, the CPU efficiency and memory efficiency are both 0.00% because the job did not use any CPU time or memory. This suggests that the job was not very resource-intensive, and that fewer resources should be requested for this job in the future.  
</details>

It is a good idea to check the efficiency of your jobs after they have completed, and to adjust your resource requests accordingly for future jobs.  

### Cancelling jobs - scancel

If you need to cancel a job that is currently running or pending, you can use the `scancel` command. You will need the job ID of the job you want to cancel, which you can find using the `squeue` or `sacct` commands.  

1. Run the `squeue --me` command to check the status of your jobs. 

```bash
squeue --me
```

Pick a job that is currently running to cancel. If there are no jobs running, submit the `hello_ccri.sbatch` job again and **wait for it to start running**.  

2. Use the `scancel` command to cancel the job. Replace `<job_id>` with the job ID of the job you want to cancel.  

```bash
scancel <job_id>
```

>[!NOTE]
>If you cancelled your interactive job while on the compute node, you will get this error message:
>
>```bash
>[codespace@node001 Introduction_to_Scientific_Computing]$ srun: Job step aborted: Waiting up to 32 seconds for job step to finish.
>[2026-08-06T13:34:26.758] error: *** STEP <job-id> ON node001 CANCELLED AT 2026-08-06T13:34:26 DUE to SIGNAL Terminated ***
>```
>
>Simply press Enter to return to the login node.

3. Now, run the `squeue --me` command again to check the status of your jobs.  

```bash
squeue --me
```

You should see that the job you cancelled is no longer in the queue or briefly shows a status of CG (short for "completing") in the ST column while Slurm finishes cleaning up its resources. Once the cleanup is complete, the job will be removed."

4. You can also use the `sacct` command to check the status of the cancelled job.  

```bash
sacct
```

```bash
JobID           JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
6                  bash interacti+      users          0 CANCELLED+      0:0 
7                  bash interacti+      users          2  COMPLETED      0:0 
7.0                bash                 users          2  COMPLETED      0:0 
8                  bash interacti+      users          0 CANCELLED+      0:0 
9                  bash interacti+      users          0     FAILED      1:0 
10                 bash interacti+      users          2 CANCELLED+      0:0 
10.0               bash                 users          2  COMPLETED      0:0 
11           example_j+      tinyq      users          2  COMPLETED      0:0 
11.batch          batch                 users          2  COMPLETED      0:0 
12           example_j+      tinyq      users          2  COMPLETED      0:0 
12.batch          batch                 users          2  COMPLETED      0:0 
13           example_j+      tinyq      users          2  COMPLETED      0:0 
13.batch          batch                 users          2  COMPLETED      0:0 
14           hello_ccri      tinyq      users          2  COMPLETED      0:0 
14.batch          batch                 users          2  COMPLETED      0:0 
15           hello_ccri      tinyq      users          2 CANCELLED+      0:0 ***
15.batch          batch                 users          2  CANCELLED     0:15 ***  
```

If an error file was specified for the job, it should contain a message similar to the following:

```bash
[2026-08-06T12:12:09.516] error: *** JOB 15 ON node004 CANCELLED AT 2026-08-06T12:12:09 DUE to SIGNAL Terminated ***
```

>[!TIP]
>To cancel all of your jobs running on a specific queue, you can use the `scancel --me --partition=tinyq` command, which will cancel all jobs in the `tinyq` queue. You can replace `tinyq` with the name of any other queue to cancel all jobs in that queue.  


### Cheatsheet of useful commands

| Command | Description |
| ------- | ----------- |
| `sinfo` | Show the "states" of nodes in each queue. |
| `squeue` | Show the status of jobs in the queue. You can use the `-p partition` option to show only jobs from a specific queue, or the `--me` option to show only your jobs. |
| `scontrol show job <job_id>` | Show detailed information about a specific job, including its status, resources, and output files. |
| `scontrol update JobID=<jobid> timelimit=<new_time>` | Change the time limit of a specific job. |
| `seff <job_id>` | Show the efficiency of a specific job, including its CPU and memory usage. |
| `sacct` | Show information about completed jobs, including their status, resources, and exit codes. |
| `scancel <job_id>` | Cancel a job that is currently running or pending. |

**You are done when:**

- You have successfully tracked the general usage of the cluster using the `sinfo` and `squeue` commands.  
- You have successfully tracked the status of your jobs using the `squeue --me`, `scontrol`, and `sacct` commands.  
- You have successfully cancelled a job using the `scancel` command.  

## End of Session 3

Yay, you have made it to the end of Session 3! You should now have a good understanding of how to submit jobs to SLURM, track their status, and cancel them if necessary. You should also have a good understanding of the different queues, and how to choose the appropriate queue for your job based on its resource requirements and expected runtime. See you in Session 4 to run some real bioinformatics tools on the CeMM cluster!
