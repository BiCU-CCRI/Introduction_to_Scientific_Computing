# Introduction to Scientific Computing - Session 4  

Welcome to Session 4 of the Introduction to Scientific Computing course! For this session we will be focusing on running R and Jupyter Notebook from the CeMM cluster.  

## Overview
  
Today we'll cover:  

1. Exercise 1: Logging onto a computing cluster using SSH  
2. Understanding the CeMM cluster architecture  
3. Understanding the CeMM cluster file storage systems  
4. Exercise 2: Environment management using the module system
5. Exercise 3: Variant calling on the CeMM cluster
6. Exercise 4: Running a Jupyter Notebook session on the CeMM cluster 
7. Exercise 5: Running an RStudio session on the CeMM cluster 

## 1. Exercise 1: Logging onto a computing cluster using SSH  

**Goal:** Learn how to log onto the CeMM cluster using SSH from a terminal or VSCode. 

The first step to accessing the CeMM cluster, or any high performance computing cluster, is to log in using SSH (Secure Shell). SSH is a protocol that allows you to securely connect to a remote server or computer over a network.  

### Logging onto the CeMM cluster from the terminal  

1. Make sure you are connected to the CCRI network (either via VPN or on-site at CCRI).  

2. Open a terminal on your local machine (Linux or Mac) or use a terminal emulator like PuTTY (Windows).  

3. Use the following command to connect to the CeMM cluster:  

   ```bash
   ssh <username>@login.int.cemm.at
   ```

4. Enter your CeMM password when prompted.  

### Logging onto the CeMM cluster using VSCode  

1. Open VSCode.  

2. Cmd + Shift + P (Mac) or Ctrl + Shift + P (Windows) to open the command palette.  

3. Type "Remote-SSH: Connect to Host..." and select it.  

4. Enter the following in the input box: `<username>@login.int.cemm.at` and press Enter.  

5. Enter your CeMM password when prompted.  

Voilà! You are now logged onto the CeMM cluster. You should see a command prompt indicating that you are on the cluster:

```bash
############################################################################
Cluster details and information:
https://cemmat.sharepoint.com/sites/IT-Resources/SitePages/Lustre-Cluster.aspx

Required Metadata information:
https://cemmat.sharepoint.com/sites/data-management
############################################################################
```

You can now start running commands and scripts on the cluster. How exciting.  

## 2. Understanding the CeMM cluster architecture

The CeMM cluster is a high-performance computing environment that consists of multiple nodes, each with its own resources (CPU, memory, storage). The cluster is designed to handle large-scale computations and data analysis tasks.

When you first log in, you are on a **login node**. Login nodes are used for interactive tasks such as editing files, writing code, and submitting jobs. However, they are not meant for running long computations or resource-intensive tasks.

To run more computationally intensive jobs, you should use a **compute node**. Compute nodes are designed to handle heavy workloads and can be accessed by submitting jobs through a job scheduler (SLURM). We will go over SLURM and how to submit jobs to compute nodes in the next session.  

Here is an overview of the different node types available on the CeMM cluster:

<img width="1223" height="367" alt="node_types" src="https://github.com/user-attachments/assets/5cac0861-c0e8-48de-8b4b-9476dbc0a062" />

## 3. Understanding the CeMM cluster file storage systems  

The CeMM cluster has two main file storage systems: `/nobackup` and `/research`. Each of these storage systems serves different purposes and has different characteristics.  

- `/research` : This is a backed-up file system used by the CeMM research groups for storing raw data only. As CCRI research groups, we will not use `/research` except in rare cases, since our main storage system is the Isilon file system hosted at the CCRI. Some exceptions are for example adjunct PIs who may store raw data on `/research`, and shared resources provided by BiCU which are stored in `/research/lab_ccri_bicu/public`.

- `/nobackup` : As the name suggests, this is a non-backed-up file system that is used for temporary storage of data and files, for example while running analyses. This is the main file system that we will use as CCRI users. Each lab has a dedicated folder in `/nobackup` where they can store their data and files. The path to your lab's folder is `/nobackup/<lab_name>`.  

Let's take a look at what your lab already has in `/nobackup` by running the following command on the login node:

```bash
ls /nobackup/<lab_name>
```  

Both `/nobackup` and `/research` have storage quotas that limit the amount of data that can be stored per group. The storage quota for `/nobackup` is 24 TB per lab, while the storage quota for `/research` is 100 GB per lab member.  

Let's check how much storage your lab is currently using by running the following commands on the login node:

```bash
lfs quota -h -g <lab_name> /nobackup/
lfs quota -h -g <lab_name> /research/
```

Your group's data manager is in charge of making sure that the group does not exceed the storage quota. As a user, your main responsibility is to make sure that you regularly transfer your data back to Isilon for long-term storage. You should be aware that files stored in `/nobackup` may be deleted without warning, so it is doubly important to regularly back up important data to Isilon.  

## 4. Exercise 2: Creating your workspace for session 4

**Goal:** Create a workspace for session 4 in your lab's folder in `/nobackup`.

1. Navigate to your lab's folder in `/nobackup`:

```bash
cd /nobackup/<lab_name>
```

2. If it doesn't already exist, create a folder with your username and navigate into it:  

```bash
mkdir -p <username>
cd <username>
```

3. Clone this repository into your workspace:

```bash
git clone https://github.com/BiCU-CCRI/Introduction_to_Scientific_Computing.git
```

You should see s new folder called `Introduction_to_Scientific_Computing` in your workspace. Navigate into the `session_4` folder:

```bash
cd Introduction_to_Scientific_Computing/session_4
```

**You are done when:**

- You have successfully created a workspace for yourself in your lab's folder in `/nobackup`.
- You have successfully cloned the `Introduction_to_Scientific_Computing` repository into your workspace and navigated into the `session_4` folder

## Exercise 2: Environment management using the module system  

**Goal:** Learn how to load and unload software modules.

In Session 1, we learned how to manage software environments using conda. However, on a computing cluster, it is often more efficient to use a module system to manage software environments.  

Many clusters use a module system to manage software environments. This allows us to easily load and unload different versions of software as needed without having to build and install them ourselves.

Here are some basic commands to get you started with the module system:  

| Command | Description |
|---------|-------------|
| `module avail` | List all available modules on the system. Enter `q` to quit. |
| `module spider <module_name>` | Search for a module and display information about it. Enter `q` to quit. |
| `module load <module_name>` | Load a specific module into your environment. |
| `module unload <module_name>` | Unload a specific module from your environment. |
| `module list` | List all currently loaded modules in your environment. |
| `module purge` | Unload all currently loaded modules from your environment. |
| `module help <module_name>` | Display help information for a specific module. |
| `module show <module_name>` | Display detailed information about a specific module, including its path and dependencies. | 

Let's try to run a simple Python script which loads the `numpy` module and prints its version.  

>[NOTE!]
>If you are already using conda on the CeMM cluster and have Python installed in your base environment, please deactivate your base environment before running the commands below.  

2. Try to run the script from Session 1 that checks the `numpy` version without loading any modules first:

```bash
python ../session_1/check_numpy_version.py
```

You should get the following error message:  

```bash
bash: python: command not found
```

3. Now, using the commands above, try to find a Python module and load it. Then, try to run the script again.  

```bash
module spider Python
```

```bash
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Python:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Description:
      Python is a programming language that lets you work more quickly and integrate your systems more effectively.

     Versions:
        Python/2.7.18-GCCcore-9.3.0
        Python/2.7.18-GCCcore-10.2.0
        Python/2.7.18-GCCcore-9.3.0
        Python/2.7.18-GCCcore-10.2.0
        Python/2.7.18-GCCcore-11.2.0-bare
        Python/2.7.18-GCCcore-11.2.0
        Python/2.7.18-GCCcore-11.3.0-bare
        Python/2.7.18-GCCcore-12.2.0-bare
        Python/3.8.2-GCCcore-9.3.0
        Python/3.8.6-GCCcore-10.2.0
        Python/3.8.8-GCCcore-10.2.0
        Python/3.9.5-GCCcore-10.3.0-bare
        Python/3.9.5-GCCcore-10.3.0
        Python/3.9.6-GCCcore-11.2.0-bare
        Python/3.9.6-GCCcore-11.2.0
        Python/3.10.4-GCCcore-11.3.0-bare
        Python/3.10.4-GCCcore-11.3.0
        Python/3.10.8-GCCcore-12.2.0-bare
        Python/3.10.8-GCCcore-12.2.0
        Python/3.11.3-GCCcore-12.3.0
        Python/3.11.5-GCCcore-13.2.0
        Python/3.12.3-GCCcore-13.3.0
        Python/3.13.1-GCCcore-14.2.0
        Python/3.13.5-GCCcore-14.3.0
     Other possible modules matches:
        Biopython  GitPython  IPython  Python-bundle  Python-bundle-PyPI  bio/Biopython  bio/bx-python  bio/intervaltree-python  bio/python-parasail  bx-python  devel/flatbuffers-python  ...

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  To find other possible module matches execute:

      $ module -r spider '.*Python.*'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  For detailed information about a specific "Python" package (including how to load the modules) use the module's full name.
  Note that names that have a trailing (E) are extensions provided by other modules.
  For example:

     $ module spider Python/3.13.5-GCCcore-14.3.0
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
```

```bash
module load Python/3.10.8-GCCcore-12.2.0
module list
# 12) Python/3.10.8-GCCcore-12.2.0
python check_numpy_version.py
```

Hm, now we have Python loaded, but not `numpy`. You should get the following error message:

```bash
Traceback (most recent call last):
  File "path/to/Introduction_to_Scientific_Computing/session_3/check_numpy_version.py", line 1, in <module>
    import numpy as np
ModuleNotFoundError: No module named 'numpy'
```

4. Now, let's try to find a `numpy` module and load it. Then, try to run the script again.  

```bash
module spider numpy
```

```bash
-----------------------------------------------------------------------------------------------
  numpy: numpy/2.3.1 (E)
-----------------------------------------------------------------------------------------------
    This extension is provided by the following modules. To access the extension you must load one of the following modules. Note that any module names in parentheses show the module location in the software hierarchy.


       lang/SciPy-bundle/2025.06-gfbf-2025a
       SciPy-bundle/2025.06-gfbf-2025a


Names marked by a trailing (E) are extensions provided by another module.

-----------------------------------------------------------------------------------------------
  numpy:
-----------------------------------------------------------------------------------------------
     Versions:
        numpy/1.16.6 (E)
        numpy/1.20.3 (E)
        numpy/1.21.3 (E)
        numpy/1.22.3 (E)
        numpy/1.23.5 (E)
        numpy/1.24.2 (E)
        numpy/1.25.1 (E)
        numpy/1.26.2 (E)
        numpy/1.26.4 (E)
        numpy/2.3.1 (E)

Names marked by a trailing (E) are extensions provided by another module.


-----------------------------------------------------------------------------------------------
  For detailed information about a specific "numpy" package (including how to load the modules) use the module's full name.
  Note that names that have a trailing (E) are extensions provided by other modules.
  For example:

     $ module spider numpy/2.3.1
-----------------------------------------------------------------------------------------------
```

This time, we can see that the `numpy` module is an extension provided by the `SciPy-bundle` module. So, we need to load the `SciPy-bundle` module.  

```bash
module load SciPy-bundle/2025.06-gfbf-2025a

# The following have been reloaded with a version change:
#   1) GCCcore/12.2.0 => GCCcore/14.2.0
#   2) Python/3.10.8-GCCcore-12.2.0 => Python/3.13.1-GCCcore-14.2.0
#   3) SQLite/3.39.4-GCCcore-12.2.0 => SQLite/3.47.2-GCCcore-14.2.0
#   4) Tcl/8.6.12-GCCcore-12.2.0 => Tcl/8.6.16-GCCcore-14.2.0
#   5) XZ/5.2.7-GCCcore-12.2.0 => XZ/5.6.3-GCCcore-14.2.0
#   6) binutils/2.39-GCCcore-12.2.0 => binutils/2.42-GCCcore-14.2.0
#   7) bzip2/1.0.8-GCCcore-12.2.0 => bzip2/1.0.8-GCCcore-14.2.0
#   8) libffi/3.4.4-GCCcore-12.2.0 => libffi/3.4.5-GCCcore-14.2.0
#   9) libreadline/8.2-GCCcore-12.2.0 => libreadline/8.2-GCCcore-14.2.0
#  10) ncurses/6.3-GCCcore-12.2.0 => ncurses/6.5-GCCcore-14.2.0
#  11) zlib/1.2.12-GCCcore-12.2.0 => zlib/1.3.1-GCCcore-14.2.0
```

The `SciPy-bundle` module has reloaded several other modules, including `Python`, to newer versions. Now, let's check if the script runs successfully:

```bash
python check_numpy_version.py
# 2.3.1
```

### Loading modules in a job script  

To load modules in a job script, you can simply use the `module load` command in your script.  

Create a new job script called `check_numpy_version_module_job.sbatch` which loads the `Python/3.10.8-GCCcore-12.2.0` and `SciPy-bundle/2025.06-gfbf-2025a` modules, and then runs the `check_numpy_version.py` script.  

Example script:  

```bash
#!/bin/bash

#SBATCH --job-name=check_numpy_version_module_job
#SBATCH --output=check_numpy_version_module_job.out
#SBATCH --error=check_numpy_version_module_job.err
#SBATCH --time=00:10:00
#SBATCH --mem=1G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=tinyq
#SBATCH --qos=tinyq

module load Python/3.10.8-GCCcore-12.2.0
module load SciPy-bundle/2025.06-gfbf-2025a

python check_numpy_version.py
```

**You are done when:** 

- You are comfortable loading and unloading modules using the module system.  
- You can run the `check_numpy_version.py` script successfully after loading the appropriate modules.  

## 5. Exercise 3: Variant calling on the CeMM cluster

**Goal:** Repeat the variant calling pipeline from Session 2, this time on the CeMM cluster using SLURM job scripts.

Now that you are familiar with the CeMM cluster architecture, file storage systems, and module system, we will repeat the variant calling pipeline from Session 2, this time on the CeMM cluster using SLURM job scripts.  

1. First, make yourself a working directory and navigate into it:
    
```bash
mkdir -p /nobackup/<lab_name>/<username>/Introduction_to_Scientific_Computing/session_4/variant_calling_work_dir
cd /nobackup/<lab_name>/<username>/Introduction_to_Scientific_Computing/session_4/variant_calling_work_dir
```

Make `results` and `logs` directories like last time, and this time also make a `logs/slurm_logs` directory so you can distinguish between the output and error files from the SLURM scheduler and the output and error files from the software you are running in your scripts:

```bash
mkdir -p results logs/slurm_logs
```

2. Next, copy the scripts from the variant calling pipeline in Session 2 into your working directory. You can use the `cp` command to copy the scripts from `session_2/variant_calling_examples/example_scripts`:

```bash
cp ../../session_2/variant_calling_examples/example_scripts/* .
```

3. Now, turn each `.sh` script into a `.sbatch` script. We encourage you to write your own scripts, but if you get really stuck, you can check the example scripts in `session_4/variant_calling_examples/example_scripts`.  

For each script:

- Change the file extension from `.sh` to `.sbatch`.

- Add SLURM directives to specify the resources you need for the job. Since we are working with test data, we can request few resources, but for a real analysis, you would need to request more resources (e.g. at least 40 GB for the `bwa` step).

- Use the `--output` and `--error` directives to specify the names of the output and error files for the job. This will help you keep track of the progress of your analysis and troubleshoot any issues that arise.  

- Load the appropriate modules for the software used in the script. You can use `module spider` command in the terminal first to find the modules you need, then use `module load` in your job script to load them.

- Remember to match any software parameters that specify the number of threads to use with the number of CPUs you request in your job script.

- Remember to change the file paths in the scripts to point to the correct locations of your input files and output directories on the CeMM cluster.  

4. Submit the scripts one by one to the SLURM scheduler using the `sbatch` command. You can check the status of your jobs using the `squeue` command. Wait until each job has completed before submitting the next one. You can check the output and error files for each job to see if there were any issues, as we did in Session 2.  

5. Once you are done, check that all of the results and log files are present.  

```bash
tree results
```

```bash
/path/to/results
├── 01_fastp
│   ├── SRR7890883.chr17_50k.html
│   ├── SRR7890883.chr17_50k.json
│   ├── SRR7890883.chr17_50k_R1_trimmed.fastq
│   └── SRR7890883.chr17_50k_R2_trimmed.fastq
├── 02_bwa
│   ├── SRR7890883.chr17_50k.bam
│   └── SRR7890883.chr17_50k.bam.bai
├── 03_markdup
│   ├── SRR7890883.chr17_50k.markdup.bai
│   ├── SRR7890883.chr17_50k.markdup.bam
│   └── SRR7890883.markdup.metrics.txt
├── 04_bqsr
│   ├── SRR7890883.recal.bai
│   ├── SRR7890883.recal.bam
│   ├── SRR7890883.recal.bam.bai
│   └── SRR7890883.recal.table
└── 05_mutect2
    ├── SRR7890883.filtered.vcf.gz
    ├── SRR7890883.filtered.vcf.gz.filteringStats.tsv
    ├── SRR7890883.filtered.vcf.gz.tbi
    ├── SRR7890883.pass.vcf.gz
    ├── SRR7890883.pass.vcf.gz.tbi
    ├── SRR7890883.unfiltered.vcf.gz
    ├── SRR7890883.unfiltered.vcf.gz.stats
    └── SRR7890883.unfiltered.vcf.gz.tbi

5 directories, 21 files
```

```bash
tree logs
```

```bash
/path/to/logs/
├── 01_fastp
│   └── SRR7890883.fastp.log
├── 02_bwa
│   └── SRR7890883.bwa.log
├── 03_markdup
│   └── SRR7890883.markdup.log
├── 04_bqsr
│   ├── SRR7890883.apply_bqsr.log
│   └── SRR7890883.base_recalibrator.log
├── 05_mutect2
│   ├── SRR7890883.filter_mutect_calls.log
│   ├── SRR7890883.mutect2.log
│   └── SRR7890883.select_pass_variants.log
└── slurm_logs
    ├── bqsr_13108580.err
    ├── bqsr_13108580.out
    ├── bwa_13108574.err
    ├── bwa_13108574.out
    ├── fastp_13108573.err
    ├── fastp_13108573.out
    ├── markdup_13108577.err
    ├── markdup_13108577.out
    ├── mutect2_13108581.err
    └── mutect2_13108581.out

6 directories, 18 files
```

7. Now, let's check the actual results files. 

First, let's check the `fastp` HTML file. If you are using VSCode, you can open the HTML file in your web browser. If you are using a terminal, you can use the `scp` command to copy the HTML file to your local machine and open it in your web browser.  

```bash
scp <username>@login.int.cemm.at:/nobackup/<lab_name>/<username>/session_4/variant_calling_work_dir/results/01_fastp/SRR7890883.chr17_50k.html .
```

- What is the total number of reads before and after trimming?
- What is the average read length before and after trimming?
- What is the number of reads that were filtered out due to low quality?

Answers:

- 100000 -> 99996
- 125 bp -> 123 bp
- 2

Next, check the aligment statistics.

```bash
module load 
samtools flagstat results/02_bwa/SRR7890883.chr17_50k.bam
```

- What is the total number of reads in the `.bam` file?
- What percentage of reads are mapped to the reference genome?

Answers:

- 100125
- 97.38%

Next, check the `MarkDuplicates` metrics table.

- How many read pairs were examined?
- What was the percentage of reads that were marked as duplicated?  

Answers:

- 47377
- 0.0099 %

Finally, let's check the Mutect2 results.

```bash
module load BCFtools/1.15.1-GCC-11.3.0
bcftools view -H results/05_mutect2/SRR7890883.pass.vcf.gz | wc -l
# 1510
bcftools view -v snps -H results/05_mutect2/SRR7890883.pass.vcf.gz | wc -l
# 1432
bcftools view -v indels -H results/05_mutect2/SRR7890883.pass.vcf.gz | wc -l
# 55
```

Even though all of the previous results were the same, a different number of variants was found with `Mutect2` than in Session 2! Why do you think this might be?  

Answer: The difference in the number of variants found with `Mutect2` could be due to differences in the software versions - in Session 2, our `somatic_variant_calling` environment used `gatk` v4.6.2.0, whereas our module system at CeMM does not have this version, so we used `gatk4` v4.1.8.1. It is therefore also likely that the `gatk4` dependencies are different between the two environments. Variants calling can be sensitive to these factors, leading to slight variations in the results. This is a good example of why it is good practice to document all of the software versions and dependencies used in your analysis, so that you can reproduce your results in the future.  

## 6. Exercise 4: Running a Jupyter Notebook session on the CeMM cluster  

>[TIP!]
>The BiCU have set up a [GitHub repository](https://github.com/BiCU-CCRI/running_rstudio_or_jupyterlab) specifically for running RStudio and Jupyter Notebook on the CeMM cluster. The scripts used in Session 4 are copied from this repository.

**Goal:** Learn how to run a Jupyter Notebook session on the CeMM cluster.

Many scientists use Jupyter Notebook for data analysis and visualization. In this exercise, we will learn how to run a Jupyter Notebook session on the CeMM cluster. This allows you to undertake analyses which require more computational resources than your local laptop can provide.  

The CeMM cluster provides a Jupyterlab module that you can load to run a Jupyter Notebook session. This module is pre-configured with a set of commonly used Python packages for data analysis and visualization.  

1. Navigate to the `session_4/jupyterlab/` directory.  

2. First, let's view the `jupyterlab.sbatch` script contents. 

```bash
#!/bin/bash
#SBATCH --partition=interactiveq
#SBATCH --qos=interactiveq
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=12:00:00
#SBATCH --job-name=jupyter-lab
#SBATCH --output=jupyter-lab-%j.log

port=$(shuf -i8000-9000 -n1)
node=$(hostname).int.cemm.at
user=$(whoami)
host ${node}

module load JupyterLab-R-autocomplete/4.9.0-foss-2023a-Python-3.11.3-R-4.2.3

jupyter lab --no-browser --port=${port} --ip=${node}
```

Can you recognize the following concepts we learnt about in Sessions 1-3?  

- SLURM directives
- bash variables
- module loading

3. Submit the script to SLURM using `sbatch` and wait for the output file to be created `jupyter-lab-<job-id>.log`. You should see a message like this at the bottom of the log file:

```bash
To access the server, open this file in a browser:
    file:///home/<username>/.local/share/jupyter/runtime/jpserver-179870-open.html
Or copy and paste one of these URLs:
    http://d021.int.cemm.at:8513/lab?token=1e434bed38321564f9d1953064f260c9e253bc8b67f59e88
    http://127.0.0.1:8513/lab?token=1e434bed38321564f9d1953064f260c9e253bc8b67f59e88
```

Click on the link starting `http://d021.int.cemm.at:8513/lab?token=...` to access the Jupyter Notebook session in your web browser. You should now be able to use Jupyter Notebook in your web browser!  

4. Let's try running an example analysis with the `example_notebook.ipynb` notebook. You can open the notebook in Jupyterlab. Run the cells to produce the example plot.  

5. What if we try to install a package that's not included in the pre-configured Jupyterlab module? Try running section 6.  

If you are interested in using a package that is not included in the pre-configured Jupyterlab module, you can create your own conda environment and use it in Jupyter Notebook. Check `extra_cemm_cluster_instructions/jupyterlab_with_custom_env.md` for instructions on how to do this.  

**You are done when:**

- You have successfully started a Jupyter Notebook session on the CeMM cluster.
- You have produced the example plot using the `example_notebook.ipynb` notebook.  

## 7. Exercise 5: Running an RStudio session on the CeMM cluster  

**Goal:** Learn how to run an RStudio session on the CeMM cluster.  

Many scientists use R - specifically RStudio - for data analysis and visualization. In this exercise, we will learn how to run an RStudio session on the CeMM cluster. This allows you to undertake analyses which require more computational resources than your local laptop can provide.  

Let's start an RStudio session on the CeMM cluster.  

1. Log onto the CeMM cluster and navigate to your local copy of `Introduction_to_Scientific_Computing/session_4/rstudio/`.  

2. We will use the `run_rstudio_apptainer_cemm.sbatch` script to start an RStudio session. First, let's view the script contents.  

```bash
#!/bin/bash
#SBATCH --job-name=rstudio_apptainer
#SBATCH --partition=interactiveq
#SBATCH --qos=interactiveq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=12:00:00
#SBATCH --output=logs/rstudio_apptainer_%j.log #slurm writes everything to --output if --error logs/rstudio_apptainer_%j.err is not set

set -ueo pipefail

workdir="$(pwd -P)"

r_version="4.4"
rstudio_apptainer_image="/research/lab_ccri_bicu/public/apptainer_images/tidyverse-${r_version}-jdk.sif"

# Other common SLURM variables https://docs.hpc.shef.ac.uk/en/latest/referenceinfo/scheduler/SLURM/SLURM-environment-variables.html#gsc.tab=0
echo "======================"
echo "Working directory:     $SLURM_SUBMIT_DIR"
echo "Job name:              $SLURM_JOB_NAME"
echo "Job id:                $SLURM_JOB_ID"
echo "Job queue (partition): $SLURM_JOB_PARTITION"
echo "Job tasks, CPUs per task: $SLURM_NTASKS, $SLURM_CPUS_PER_TASK"
echo "Job RAM:               $SLURM_MEM_PER_NODE"
echo "Job node name:         $SLURM_NODELIST"
echo "Job node address:      $(nslookup $(hostname) | grep Name: | cut -f2)"
echo "Job node IP address:   $(nslookup $(hostname) | grep Address: | tail -1 | cut -d' ' -f2)"
echo "======================"

module load apptainer/1.1.9

if [[ -z "${TMPDIR:-}" ]]; then
    TMPDIR="/tmp"
fi
mkdir -p "${TMPDIR}"

rstudio_server_config_dir="${workdir}/.rstudio_server"

mkdir -p -m 700 "${rstudio_server_config_dir}/run" "${rstudio_server_config_dir}/tmp" "${rstudio_server_config_dir}/var/lib/rstudio-server" \
    "${rstudio_server_config_dir}/R/${r_version}"

# R Session Configuration File https://docs.posit.co/ide/server-pro/reference/rsession_conf.html
cat >"${rstudio_server_config_dir}/rsession.conf" <<END
# Set R_LIBS_USER to a path specific to rocker/rstudio to avoid conflicts with personal libraries from any R installation in the host environment
r-libs-user=${rstudio_server_config_dir}/R/${r_version}
session-timeout-minutes=0
session-default-working-dir=${workdir}
END

# .Rprofile and default functions
cat >"${rstudio_server_config_dir}/.Rprofile" <<END
source("${rstudio_server_config_dir}/.Ractivate.R")
END

# Location or .Rprofile - project-wide
cat >".Renviron" <<END
R_PROFILE_USER="${rstudio_server_config_dir}/.Rprofile"
TMPDIR="${TMPDIR}"
TMP="${TMPDIR}"
END

# Functions to load at startup
cat >"${rstudio_server_config_dir}/.Ractivate.R" <<END
save_session <- function() {
    savehistory(file = "~/.Rhistory")
    save.image(file = "~/.RData")
    cat("Session saved at", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
}
END

# Apptainer tmpdir and cachedir variables
APPTAINER_CACHEDIR="$TMPDIR/apptainer_cache"
APPTAINER_TMPDIR="$TMPDIR/apptainer_tmp"
mkdir -p "${APPTAINER_CACHEDIR}" "${APPTAINER_TMPDIR}"
export APPTAINER_CACHEDIR APPTAINER_TMPDIR

# Bind RStudio Server directories
APPTAINER_BIND="${rstudio_server_config_dir}/run:/run,${rstudio_server_config_dir}/tmp:/tmp,\
${rstudio_server_config_dir}/rsession.conf:/etc/rstudio/rsession.conf,${rstudio_server_config_dir}/var/lib/rstudio-server:/var/lib/rstudio-server,\
${rstudio_server_config_dir}/run:/var/run,\
${rstudio_server_config_dir}:${rstudio_server_config_dir},\
${workdir}:/home/$(whoami),\
/nobackup:/nobackup,/research:/research"
export APPTAINER_BIND

# Do not suspend idle sessions
# Alternative to setting session-timeout-minutes=0 in /etc/rstudio/rsession.conf
# https://github.com/rstudio/rstudio/blob/v1.4.1106/src/cpp/server/ServerSessionManager.cpp#L126
export APPTAINERENV_RSTUDIO_SESSION_TIMEOUT=0
APPTAINERENV_USER="$(whoami)"
export APPTAINERENV_USER
export APPTAINERENV_PASSWORD="test0"

# Get unused socket between 8000 and 9000 (these are accessible within the CCRI network):
readonly PORT=$(python -c '
import socket
import random

def find_port_in_range(start=8000, end=9000):
    while True:
        port = random.randint(start, end)
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            try:
                s.bind(("", port))
                return port
            except OSError:
                continue

print(find_port_in_range())
')
readonly HOSTNAME=$(hostname)

cat 1>&2 <<END
To access the RStudio Server, cmd + click for Mac/ctrl + click for Windows the link or copy-paste this to your web browser:
http://${HOSTNAME}.int.cemm.at:${PORT}
END

echo "======================"
echo "Job started at: $(date)"

apptainer exec \
    --cleanenv "${rstudio_apptainer_image}" \
    rserver --www-port "${PORT}" \
    --server-user="$(whoami)" \
    --auth-none=0 \
    --auth-pam-helper-path=pam-helper

echo "Job finished at: $(date)"

echo "Job stats:"
seff "${SLURM_JOB_ID}"
echo "======================"
```

It looks more complicated than the JupyterLab scripts, but you should still be able to recognize:  

- SLURM directives
- bash variables
- module loading
- if statements
- the `mkdir -p` command
- the `cat` command
- the `seff` command

Can you find the line where we set the password? Feel free to change this if you like, but don't use anything sensitive, and DON'T commit it to GitHub!  

The script works by running an `apptainer` container with RStudio Server installed. It sets up a temporary directory for the RStudio session, configures the R environment, and starts the RStudio Server on a random port between 8000 and 9000 (these are the ports we can access from the CCRI network). The output of the script is a URL that you can use to access the RStudio session in your web browser.  

>[NOTE!]
>Apptainer is another way to manage software environments, and is more reproducible than conda or modules, but out of the scope of this course. You can find more information about Apptainer [here](https://apptainer.org/).

3. Submit the script to SLURM using `sbatch` and wait for the output file to be created in `logs/rstudio_apptainer_<job-id>.log`. You should see a message like this:

```
======================
Working directory:     /path/to/Introduction_to_Scientific_Computing/session_4/rstudio
Job name:              rstudio_apptainer
Job id:                13100216
Job queue (partition): interactiveq
Job tasks, CPUs per task: 1, 1
Job RAM:               40960
Job node name:         d009
Job node address:      d009.int.cemm.at
Job node IP address:   10.110.81.9
======================
To access the RStudio Server, cmd + click for Mac/ctrl + click for Windows the link or copy-paste this to your web browser:
http://d009.int.cemm.at:8779
======================
Job started at: Fri Jul 31 13:32:27 CEST 2026

```

Click on the link in the output. Log onto the RStudio session using your CeMM cluster username and the password you set in the script. You should now be able to use RStudio in your web browser!  

4. Try to run the `example_script.R` in the Rstudio server to produce the example plot. Loading packages and manipulating data in the RStudio session is exactly the same as on your local machine. You can also save your work in the RStudio session, and it will be saved in your home directory on the CeMM cluster.  

5. Remember to `scancel` the job once you are done with your RStudio session.  

>[NOTE!]
>To manage your R environments, we recommend using `renv`. You can find more information about `renv` [here](https://rstudio.github.io/renv/articles/renv.html).  

**You are done when:**

- You have successfully started an RStudio session on the CeMM cluster.
- You have produced the example plot using the `example_script.R` script.  

## End of the course

Woohoo, you have completed the Introduction to Scientific Computing course! Enjoy using your new skills to analyze your data. If you have any questions or feedback, please reach out to the BiCU.  