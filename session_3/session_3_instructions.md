# Introduction to Scientific Computing - Session 3  

Welcome to Session 3 of the Introduction to Scientific Computing course! Now it's time to run some real bioinformatics software.  

## Overview
  
Today we'll cover:  

1. Exercise 1: Environment management using the module system  
2. Exercise 2: Environment management using conda
3. Exercise 3: Putting it all together: somatic short variant calling analysis  

## Exercise 1: Environment management using the module system  

**Goal:** Learn how to load and unload software modules.

Now that we know how to submit jobs to a computing cluster, we need to learn how to load the software we need for our analyses. Many clusters use a module system to manage software environments. This allows us to easily load and unload different versions of software as needed.  

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

#### LearnSlurm users

Try to experiment with the module system available within the LearnSlurm environment. You can use the commands above to load and unload different modules, and to check which modules are currently loaded in your environment. Try to answer the following questions:  

- Which modules are loaded upon startup?  
- How many different versions of `pytorch` are available?  
- Where are the modules stored on the system?  

#### CeMM cluster users

Let's try to run a simple Python script which loads the `numpy` module and prints its version.  

1. Navigate to your local copy of this repository, into the `session_3` folder.

```bash
cd /nobackup/<lab_name>/<username>/Introduction_to_Scientific_Computing/session_3/
```

2. Try to run the script without loading any modules first:

```bash
python check_numpy_version.py
```

If you do not have Python installed in your base environent, you should get the following error message. If you have Python installed in your base environment, you can skip to the next step.  

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

To load modules in a job script, you can simply use the `module load` command.  

#### LearnSlurm users

Check the contents of the `mpi_job.sh` script. Can you see the line where the `mpi` module is loaded?

Submit the script and observe that it runs successfully. Now, use `nano` to delete the line loading the `mpi` module, and submit the script again. What happens?  

############################################################################################## bug in learn slurm - hopefully fixed soon

#### CeMM cluster users  

Create a new job script called `check_numpy_version_module_job.sh` which loads the `Python/3.10.8-GCCcore-12.2.0` and `SciPy-bundle/2025.06-gfbf-2025a` modules, and then runs the `check_numpy_version.py` script.  

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

## Exercise 2: Environment management using conda  

**Goal:** Learn how to create and manage isolated environments using conda.  

If you are working on several projects, you may want to use different versions of the same software for each project. This is where conda comes in handy. Conda is a package manager that allows you to create isolated environments for your projects, each with its own set of dependencies. 

>[TIP!]
>It is good practice to create a new conda environment for each project you work on. This way, you can avoid conflicts between different versions of software and ensure that your analysis is reproducible.   

Here are the steps to set up conda:  

1. Download miniconda

`wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`

2. Install miniconda

`bash Miniconda3-latest-Linux-x86_64.sh`

Follow the prompts, then restart your terminal.  

3. Add channels to your conda. Channels are the locations where conda looks for packages. The default channel is the Anaconda channel, but there are many other channels available, such as conda-forge and bioconda, which have a wider range of bioinformatics packages. To add these channels, run the following commands:

```bash
conda config --add channels conda-forge
conda config --add channels bioconda
```

4. Install `mamba` in your `base` environment. `mamba` is a fast, drop-in replacement for conda. It is written in C++ and uses parallel downloading to speed up package installation. To install `mamba`, run the following command:  

```bash
conda install -c conda-forge mamba
```

5. On the CeMM cluster, by default, packages are installed in the `home` directory, which is hosted on the `/research` partition. Since space on `/research` is limited, we will move our conda installation to the `/nobackup` partition.  

```bash
rsync -avhP /home/<username>/miniconda3/ /nobackup/<lab_name>/<username>/miniconda3/
```

Once the transfer is complete, you can remove the old conda installation from your home directory to free up space:

```bash
rm -r /home/<username>/miniconda3/
```

Now, edit your `~/.bashrc` file to point to the new location of your conda installation:  

Old `~/.bashrc`:  

```bash
 >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/ccasey/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/<username>/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/<username>/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/<username>/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
```

New `~/.bashrc`:  

```bash
 >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/nobackup/<lab_name>/<username>/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/nobackup/<lab_name>/<username>/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/nobackup/<lab_name>/<username>/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/nobackup/<lab_name>/<username>/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
```

6. Now, let's create a new conda environment for our project. We will call this environment `intro_to_sci_comp`. To create the environment, run the following command:  

```bash
mamba create -n intro_to_sci_comp python=3.10
```

We are specifying that we want to create an environment with Python version 3.10 installed.  

7. To activate the environment, run the following command:  

```bash
mamba activate intro_to_sci_comp
```

8. To install new packages in the environment, run the following command:  

```bash
mamba install <package_name>
```

You can add multiple packages by separating them with spaces. You can also specify the channel from whcih the package should be installed with `<channel>::<package_name>`, and you can specify the version of the package you want to install by appending `=<version>` to the package name. 

Try installing `numpy==2.2.6` from the channel `conda-forge` in your `intro_to_sci_comp` environment, then use the `check_numpy_version.py` script to check if it works in the new conda environment.  

```bash
python check_numpy_version.py
# 2.3.1
```

>[NOTE!]
>When installing specific versions of Python, use `=` instead of `==`.  

9. To deactivate your conda enironment and return to the base environment, run the following command:  

```bash
mamba deactivate
```

Here are some useful commands for managing conda environments (NB for most of these commands, `conda` can be replaced with `mamba`):  

| Command | Description |
|---------|-------------|
| `conda create -n <env_name> <package1> <package2> ...` | Create a new conda environment with the specified packages installed. |
| `conda activate <env_name>` | Activate a specific conda environment. |
| `conda install <package_name>` | Install a package in the current conda environment. |
| `conda remove <package_name>` | Remove a package from the current conda environment. |
| `conda deactivate` | Deactivate the current conda environment and return to the base environment. |
| `conda env list` | List all of your conda environments on the system. |
| `conda remove -n <env_name> --all` | Remove a conda environment and all of its packages. |
| `conda list` | List all packages installed in the current conda environment. |
| `conda clean -ay` | Clean up unused packages and caches to free up space. |

**You are done when:**

- You have installed Miniconda.  
- You have made the necessary changes to your `~/.bashrc` file to point to the new location of your conda installation.  
- You have created a new environment called `intro_to_sci_comp` with Python 3.10 installed.  
- You have activated the `intro_to_sci_comp` environment and successfully run the `check_numpy_version.py` script.  
- You have installed `numpy` in the `intro_to_sci_comp` environment and successfully run the modified `check_numpy_version.py` script.  
- You have deactivated the `intro_to_sci_comp` environment and returned to the base environment.  

### Activating a conda environment in a job script

To activate a conda environment in a job script, you cannot just use `conda activate <env_name>`. Instead, you need to source the `conda.sh` script and then activate the environment. Here is an example of how to do this in a job script:  

```bash
conda_env_name="example_env"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"
```

Try this out for yourself - create a new job script called `check_numpy_version_conda_job.sh` which activates the `intro_to_sci_comp` conda environment and then runs the `check_numpy_version.py` script.  

>[!NOTE]
>When you submit the `.sbatch` script, you should not have your `intro_to_sci_comp` conda environment activated in your interactive session. If you do, the job will fail because the job script will not be able to find the conda environment. You must have your `base` conda environment activated in your interactive session when you submit the job script.  

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

conda_env_name="intro_to_sci_comp"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"

python check_numpy_version.py
```

**You are done when:**

- You have successfully run the `check_numpy_version.py` script in a job script using both the module system and the conda environment.  

## Exercise 3: Putting it all together: somatic short variant calling analysis  

Finally, we have learnt enough to run a real bioinformatics anlaysis! In this exrcise, we will run a somatic short variant calling analysis using the GATK best practices workflow.  

This workflow is designed to identify somatic variants (mutations) in tumor samples. The workflow begins with the output of a sequencing experiment, which is typically in the form of **`.fastq`** files. These files contain the raw sequencing reads, which are then aligned to the reference genome to produce **`.cram`** files. The `.cram` files are then processed to identify mismatches with respect to the genome - variants - which are reported in a **`.vcf`** file.  

#############################################################################################################################################################################################

Here is some more detailed information about `.fastq`, `.cram`, and `.vcf` files:

- `.fastq` files  
  These files contain the raw sequencing reads generated by a sequencing experiment. Each read is represented by four lines in the file: the read identifier, the nucleotide sequence, a plus sign, and the quality scores for each base in the sequence. The quality scores indicate the confidence of each base call, with higher scores indicating higher confidence.

  ```txt
  @SRR7890883.5485
  CCCACCTTCCACCCAGCCGCAGTACCCGGCAGCTTCAGCCACTTGGGCACCTTGCCCAGGCTCCTCTTCACGGGCTGGGCCGTCCCTGGGATGGGCTCAGGGGGGACCAGCGCCCCCTCCTCAGC
  +
  AAFFFKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKFKKKKKKKKKKKKKKKKFKFAFFKKKFKKKKKKKKKKKKKKKKKKKKKK
  ```

- `.cram` files
  These files contain the aligned sequencing reads in a binary format. The `.cram` file contains information about the alignment, including the position of each read in the reference genome, the quality of the alignment, and any mismatches or gaps in the alignment.  
  
  >[NOTE!]
  > `.cram` files are compressed versions of `.bam` files, which are themselves compressed versions of `.sam` files. `.cram` and `.bam` files are binary formats, so they can only be viewed using specialized software, such as `samtools` or `IGV`. `.sam` files are text-based so can be viewed and edited using a text editor, however they are much larger than `.cram` and `.bam` files, so they are not commonly used for large-scale analyses.  

  ```txt
  read0001    99    chr1    10001    60    150M    =    10201    350    ACGTACGTACGT...    FFFFFFFFFFFF...  <optional_tags>
  ```

  The columns represent:

  ```txt
  QNAME  FLAG  RNAME  POS  MAPQ  CIGAR  RNEXT  PNEXT  TLEN  SEQ  QUAL <optional_tags>
  ```

- `.vcf` files  
  These files contain the identified variants in a text-based format. Each variant is represented by a line in the file, which includes information about the position of the variant in the reference genome, the reference and alternate alleles, and various annotations about the variant, such as its predicted impact on protein function.  

  ```txt
  ##fileformat=VCFv4.2
  ##fileDate=20260729
  ##source=ExampleVariantCaller
  ##reference=GRCh38.fa
  ##contig=<ID=chr1,length=248956422>
  ##INFO=<ID=DP,Number=1,Type=Integer,Description="Total Depth">
  ##INFO=<ID=AF,Number=A,Type=Float,Description="Allele Frequency">
  ##FILTER=<ID=PASS,Description="All filters passed">
  ##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
  ##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read Depth">
  ##FORMAT=<ID=GQ,Number=1,Type=Integer,Description="Genotype Quality">
  #CHROM	POS	  ID	        REF	ALT	QUAL	FILTER	INFO	        FORMAT	  Sample1	  Sample2
  chr1	  10176	rs367896724	A	  AC	100	  PASS	  DP=42;AF=0.50	GT:DP:GQ	0/1:20:99	0/0:22:99
  chr1	  10352	.	          T	  TA	85	  PASS	  DP=31;AF=0.33	GT:DP:GQ	0/1:15:80	0/1:16:85
  chr1	  10616	rs540431307	C	  G	  99	  PASS	  DP=50;AF=0.10	GT:DP:GQ	0/0:25:99	0/1:25:70
  chr1	  11008	.	          C	  T	  60	  PASS	  DP=18;AF=1.00	GT:DP:GQ	1/1:18:99	0/1:17:90
  ``` 


Here is some more detailed information about the GATK best practices workflow:  

a) **Pre-processing**: The first step in the workflow is to pre-process the raw sequencing reads. This involves trimming adapters and low-quality bases from the reads using `fastp`. We will need to install the `fastp` software for this step.  

b) **Alignment**: The pre-processed reads are then aligned to the reference genome using `bwa`. This step produces a set of aligned reads in `.cram` format. We will need to install the `bwa` software for this step.  

c) **Sorting and Indexing**: The aligned reads are then sorted and indexed using `samtools`. This step is important because it allows for efficient access to the aligned reads during downstream analyses. We will need to install the `samtools` software for this step.  

d) **Marking PCR duplicates**: The aligned reads are then processed to mark PCR duplicates using `gatk MarkDuplicates`. This step is important because PCR duplicates can introduce bias into the variant calling process. We will need to install the `gatk` software for this step.  

e) **Base Quality Score Recalibration (BQSR)**: The aligned reads are then processed to recalibrate the base quality scores using `gatk BaseRecalibrator` and `gatk ApplyBQSR`. This step is important because the base quality scores can be biased by various factors, such as sequencing chemistry and machine errors. We will need to install the `gatk` software for this step.  

f) **Variant Calling**: The aligned reads are then processed to identify variants using `mutect2`. This step produces a set of identified variants in `.vcf` format. We will need to install the `gatk` software for this step.  

#############################################################################################################################################################################################

Here are some hints to help you get started with the analysis. For a full set of example scripts and expected outputs, please see the `session_3/exercise_3` folder.  

1. First, use `conda` to create a new environment for your analysis named `somatic_variant_calling`. Install the following packages in the environment: `python=3.10`, `fastp==0.23.4`, `bwa==0.7.17`, `samtools==1.16.1`, and `bioconda::gatk4==4.4.0.0`.  

NB. if you are using the CeMM cluster, run the environment creation command on an interactive node. This might take some time to resolve. In the meantime, start working on writing the scripts.  

2. Next, create a working directory for your analysis, and an output directory for your output files. `cd` to your working directory.  

>[REMINDER!]
>Your working directory is where you will run your analysis, and your output directory is where you will store the output files from your analysis. It is good practice to keep your working directory and output directory separate, so that you can easily find your output files later.  

3. Now, write `.sbatch` job scripts for the different steps in the analysis. For each job script, remember to:

- Activate the `somatic_variant_calling` conda environment, or load the appropriate modules.
- Use SLURM directives to specify the resources you need for the job. Since we are working with test data, we can request few resources, but for a real analysis, you would need to request more resources (e.g. at least 40 GB for the `bwa` step).  
- Remember to match any software parameters that specify the number of threads to use with the number of CPUs you request in your job script.  
- Use the `--output` and `--error` directives to specify the names of the output and error files for the job. This will help you keep track of the progress of your analysis and troubleshoot any issues that arise.

4. First, write a job script to run `fastp`. You can use the following command for `fastp`. Remember to change the names of the input and output files to match your own files.  

For more information about the command and arguments, check the [fastp documentation](https://github.com/OpenGene/fastp).

>[TIP!]
>The example commands use bash variables to store the names of the input and output files, as well as the read group information. This makes it easier to change the names of the files and read group information without having to edit the command itself. For a refresher on bash variables, check your notes or the course content from Introduction to Linux.  

```bash
SAMPLE="SRR7890883"                                                             # sample name
IN_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/fastq"       # input directory for raw fastq files 
OUT_DIR="/path/to/results/01_fastp"                                             # output directory for trimmed fastq files
LOG="/path/to/logs/fastp_${SAMPLE}.log"                                         # log file for fastp output

mkdir -p "${OUT_DIR}"                                           # create output directory if it does not exist

RAW_R1="${IN_DIR}/${SAMPLE}.chr17_50k_R1.fastq"                 # input file for raw read 1
RAW_R2="${IN_DIR}/${SAMPLE}.chr17_50k_R2.fastq"                 # input file for raw read 2
TRIMMED_R1="${OUT_DIR}/${SAMPLE}.chr17_50k_R1_trimmed.fastq"    # output file for trimmed read 1
TRIMMED_R2="${OUT_DIR}/${SAMPLE}.chr17_50k_R2_trimmed.fastq"    # output file for trimmed read 2
FASTP_HTML="${OUT_DIR}/${SAMPLE}.chr17_50k.html"                # output file for fastp HTML report
FASTP_JSON="${OUT_DIR}/${SAMPLE}.chr17_50k.json"                # output file for fastp JSON report

fastp \
    --in1 "${RAW_R1}" \
    --in2 "${RAW_R2}" \
    --out1 "${TRIMMED_R1}" \
    --out2 "${TRIMMED_R2}" \
    --detect_adapter_for_pe \
    --thread 1 \
    --html "${FASTP_HTML}" > "${LOG}" 2>&1
```

You should be able to see the trimmed reads in the output files `sample_R1.trimmed.fastq.gz` and `sample_R2.trimmed.fastq.gz`. You can use `zless` to view the trimmed reads. You can also open the HTML report in a browser to see a summary of the trimming process.  

4. Next, write an `sbatch` job script to run `bwa` and to sort and index the resulting alignments using `samtools`. We can do these three steps in one go because the output of `bwa` is piped directly into `samtools sort`, which sorts the alignments and writes them to a `.cram` file. It also makes sense to store the alignment and index files together.  

You can use the following commands for `bwa` and `samtools`. Remember to match the number of threads to the number of CPUs you request in your job script, and to change the names of the input and output files to match your own files.  

For more information about the commands and arguments, check the [bwa manual](https://bio-bwa.sourceforge.net/bwa.shtml) and the [samtools manual](http://www.htslib.org/doc/samtools.html).  

```bash
SAMPLE="SRR7890883"                                                         # sample name
IN_DIR="/path/to/results/01_fastp"                                          # input directory for trimmed fastq files
OUT_DIR="/path/to/results/02_bwa"                                           # output directory for aligned reads
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"    # reference genome directory
LOG="path/to/logs/bwa_${SAMPLE}.log"                                        # log file for bwa output

mkdir -p "${OUT_DIR}"                                           # create output directory if it does not exist

LIBRARY="lib1"                                                  # library name
PLATFORM="ILLUMINA"                                             # platform name
FASTP_R1="${IN_DIR}/${SAMPLE}.chr17_50k_R1_trimmed.fastq"       # input file for trimmed read 1
FASTP_R2="${IN_DIR}/${SAMPLE}.chr17_50k_R2_trimmed.fastq"       # input file for trimmed read 2
OUT_CRAM="${OUT_DIR}/${SAMPLE}.chr17_50k.cram"                  # output file for aligned reads
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"            # reference genome file

READ_GROUP="@RG\tID:${SAMPLE}.${LIBRARY}\tSM:${SAMPLE}\tLB:${LIBRARY}\tPL:${PLATFORM}\tPU:${SAMPLE}.${LIBRARY}"     # read group information

bwa mem \
    -t 1 \ 
    -M \
    -R "${READ_GROUP}" \
    "${REF}" \
    "${FASTP_R1}" \
    "${FASTP_R2}" \
    2> "${LOG}" |
samtools sort \
    -@ 1 \
    -O CRAM \
    --reference "${REF}" \
    -o "${OUT_CRAM}" \
    -

samtools index \
    -@ 1 \
    "${OUT_CRAM}"
```

5. Now, write an `sbatch` job script to run `gatk MarkDuplicates`. This step marks PCR duplicates in the aligned reads. We will need to specify the input and output files, as well as the metrics file, which contains information about the number of duplicates found in the input file.  

You can use the following command for `gatk MarkDuplicates`.  

For more information about the command and arguments, check the [GATK MarkDuplicates documentation](https://gatk.broadinstitute.org/hc/en-us/articles/13832748517275-MarkDuplicates-Picard).  

```bash
SAMPLE="SRR7890883"                                                         # sample name     
IN_DIR="/path/to/results/02_bwa"                                            # input directory for aligned reads
OUT_DIR="/path/to/results/03_markdup"                                       # output directory for marked duplicates
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"    # reference genome directory
LOG="/path/to/logs/markdup_${SAMPLE}.log"                                   # log file for markdup output

mkdir -p "${OUT_DIR}"                                                       # create output directory if it does not exist

IN_CRAM="${IN_DIR}/${SAMPLE}.chr17_50k.cram"                                # input file for aligned reads
OUT_CRAM="${OUT_DIR}/${SAMPLE}.chr17_50k.markdup.cram"                      # output file for marked duplicates
METRICS="${OUT_DIR}/${SAMPLE}.markdup.metrics.txt"                          # metrics file for marked duplicates
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"                        # genome reference file

gatk --java-options "-Xmx10g" MarkDuplicates \
    --INPUT "${IN_CRAM}" \
    --OUTPUT "${OUT_CRAM}" \
    --METRICS_FILE "${METRICS}" \
    --REFERENCE_SEQUENCE "${REF}" \
    --CREATE_INDEX true \
    --VALIDATION_STRINGENCY SILENT \
    --OPTICAL_DUPLICATE_PIXEL_DISTANCE 2500 > "${LOG}" 2>&1
```

6. Next, write a `sbatch` job script to run BQSR. You can use the following command for `gatk BaseRecalibrator` and `gatk ApplyBQSR`. We will also index the recalibrated CRAM as this is required for the variant calling step. For more information about the commands and arguments, check the [GATK BaseRecalibrator documentation](https://gatk.broadinstitute.org/hc/en-us/articles/13832708374939-BaseRecalibrator) and [GATK ApplyBQSR documentation](https://gatk.broadinstitute.org/hc/en-us/articles/13832692459163-ApplyBQSR).  

```bash
SAMPLE="SRR7890883"                     # sample name
IN_DIR="/path/to/results/03_markdup"    # input directory for marked duplicates
OUT_DIR="/path/to/results/04_bqsr"      # output directory for base quality score recalibration
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"        # reference genome directory
KNOWN_SNPS="/path/to/Introduction_to_Scientific_Computing/example_data/known_sites/dbsnp_146.hg38.chr17.vcf.gz"     # known SNPs file
KNOWN_INDELS="/path/to/Introduction_to_Scientific_Computing/example_data/known_sites/Mills_and_1000G_gold_standard.indels.hg38.chr17.vcf.gz"        # known indels file
LOG_BR="/path/to/logs/base_recalibrator_${SAMPLE}.log"      # log file for base recalibrator output
LOG_BQSR="/path/to/logs/apply_bqsr_${SAMPLE}.log"           # log file for apply bqsr output

mkdir -p "${OUT_DIR}"                                       # create output directory if it does not exist

IN_CRAM="${IN_DIR}/${SAMPLE}.chr17_50k.markdup.cram"        # input file for marked duplicates
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"        # reference genome file
RECAL_TABLE="${OUT_DIR}/${SAMPLE}.recal.table"              # output recalibrated table
OUT_CRAM="${OUT_DIR}/${SAMPLE}.recal.cram"                  # output recalibrated cram file

gatk --java-options "-Xmx10g" BaseRecalibrator \
    -R "${REF}" \
    -I "${IN_CRAM}" \
    --known-sites "${KNOWN_SNPS}" \
    --known-sites "${KNOWN_INDELS}" \
    -O "${RECAL_TABLE}" \
    2> "${LOG_BR}"

gatk --java-options "-Xmx10g" ApplyBQSR \
    -R "${REF}" \
    -I "${IN_CRAM}" \
    --bqsr-recal-file "${RECAL_TABLE}" \
    -O "${OUT_CRAM}" \
    2> "${LOG_BQSR}"

samtools index \
    -@ "${SLURM_CPUS_PER_TASK}" \
    "${OUT_CRAM}"
```

7. Finally, it's time to run `gatk Mutect2` to call somatic variants. You can use the following command for `gatk Mutect2`. For more details about the arguments used, see the [GATK Mutect2 documentation](https://gatk.broadinstitute.org/hc/en-us/articles/360037593851-Mutect2).

```bash
SAMPLE="SRR7890883"
IN_DIR="/path/to/Introduction_to_Scientific_Computing/session_3/exercise_3/expected_outputs/results/04_bqsr"        # input directory for base quality score recalibration
OUT_DIR="/path/to/Introduction_to_Scientific_Computing/session_3/exercise_3/expected_outputs/results/05_mutect2"    # output directory for mutect2 results
REF_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/ref"                                            # reference genome directory
GERM_DIR="/path/to/Introduction_to_Scientific_Computing/example_data/germline_resource"                             # germline resource directory
LOG_DIR="/path/to/logs"

mkdir -p "${OUT_DIR}"                                                                               # create output directory if it does not exist         

IN_CRAM="${IN_DIR}/${SAMPLE}.recal.cram"                                                            # input file for base quality score recalibration
REF="${REF_DIR}/Homo_sapiens_assembly38.chr17.fasta"                                                # reference genome gile
GERMLINE_RESOURCE="${GERM_DIR}/gnomAD.r2.1.1.GRCh38.chr17.PASS.AC.AF.only.vcf.gz"                   # germline resource file

UNFILTERED_VCF="${OUT_DIR}/${SAMPLE}.unfiltered.vcf.gz"                                             # output file for unfiltered variants
FILTERED_VCF="${OUT_DIR}/${SAMPLE}.filtered.vcf.gz"                                                 # output file for filtered variants
PASS_VCF="${OUT_DIR}/${SAMPLE}.pass.vcf.gz"                                                         # output file for filtered variants passing QC check

gatk --java-options "-Xmx10g" Mutect2 \
    -R "${REF}" \
    -I "${IN_CRAM}" \
    --germline-resource "${GERMLINE_RESOURCE}" \
    -O "${UNFILTERED_VCF}" \
    2> "${LOG_DIR}/mutect2.${SAMPLE}.log"

gatk --java-options "-Xmx56g" FilterMutectCalls \
    -R "${REF}" \
    -V "${UNFILTERED_VCF}" \
    -O "${FILTERED_VCF}" \
    2> "${LOG_DIR}/mutect2.filter_mutect_calls.${SAMPLE}.log"

gatk --java-options "-Xmx10g" SelectVariants \
    -R "${REF}" \
    -V "${FILTERED_VCF}" \
    --exclude-filtered true \
    -O "${PASS_VCF}" \
    2> "${LOG_DIR}/mutect2.select_pass_variants.${SAMPLE}.log"

echo "Filtered VCF: ${FILTERED_VCF}"
echo "PASS VCF:     ${PASS_VCF}"
```

8. Check your output files. You should have a `pass.vcf.gz` file with the identified variants. Try gunzipping the file and vieweing the contents using `less`. You should see a header section followed by a list of variants.  

How might we identify high-confidence somatic variants from this `.vcf` file? Do you know what the next steps would be to validate these variants and determine their potential impact on protein function?  

**You are done when:**

- You have successfully run the somatic short variant calling analysis using the GATK best practices workflow.  

## End of Session 3

Congratulations, you have run a real bioinformatics analysis! You have learned how to use the module system and conda to manage software dependencies, and you have gained experience with the GATK best practices workflow for somatic short variant calling.  

Join us in Session 4 to learn how to run a Jupyter Notebook and an Rstudio session on the CeMM cluster, and how to transfer data to/from the CeMM cluster.  