# Introduction to Scientific Computing - Session 1  

Welcome to the Introduction to Scientific Computing course! This course is designed for St. Anna CCRI users who want to learn how to utilize the computational infrastructure (the CeMM cluster) to analyze scientific data.  

## Overview
  
Today we'll cover:  
  
1. Exercise 1: Running simple commands using the command line  
2. Exercise 2: Running a simple `.sh` script, redirection, and piping  
3. Exercise 3: Running a simple scientific computing script  
4. Exercise 4: Environment management using conda  
5. Exercise 5: Activating a conda environment in a script  

The first part should be mostly a refresher of the topics covered in the "Introduction to Linux" course, and we will continue building upon that.  

### Codespaces setup  

We will use Codespaces to the login node of a computing cluster. You can use Codespaces to practice running simple commands and scripts on a pretend cluster without needing a CeMM account. Please review the main [README.md - A guide to GitHub Codespaces](../README.md#a-guide-to-github-codespaces) for a detailed overview of Codespaces.  

1. Navigate to [https://github.com/BiCU-CCRI/Introduction_to_Scientific_Computing/tree/main](https://github.com/BiCU-CCRI/Introduction_to_Scientific_Computing/tree/main)

2. Click on the green "Code" button.

3. Select the "Codespaces" tab.

4. Click on the "Create codespace on main" button.  

5. Wait for the environment to build - this can take a few minutes the first time.  

## 1. Exercise 1: Running simple commands using the command line  

**Goal:** Refresh your memory of running simple commands using the command line, creating directories and files, and navigating the file system.  

Once your CodeSpaces is set up, you can start running **simple** commands using the command line.  

These include but are not limited to:  

- `echo "text"` : Print text to the terminal
- `ls` : List the files and directories in the current directory
- `cd <dir>` : Change the current directory
- `pwd` : Print the current working directory
- `mkdir <dir_name>` : Create a new directory
- `touch <file_name>` : Create a new empty file
- `cat <file>` : Display the contents of a file
- `cp <source> <dest>` : Copy a file or directory
- `mv <source> <dest>` : Move or rename a file or directory
- `rm <file>` : Remove a file or directory *PROCEED WITH CAUTION* as there is no undo button

To practice this, we will make a new directory called `session_1` and create a new script called `hello_ccri.sh` inside it.

1. Navigate to the `session_1` directory and list its contents:  

```bash
cd session_1/
ls 
```

You should see the following output:

```bash
check_numpy_version.py  print_and_count_reads.sh  session_1_instructions.md  somatic_variant_calling.yaml
```

2. Make a new directory called `scripts` and navigate into it:

```bash
mkdir scripts
cd scripts/
pwd
```

```bash
/workspaces/Introduction_to_Scientific_Computing/session_1/scripts
```

3. Using the Explore tab on the left side of the Codespaces interface, create a new file called `hello_ccri.sh` and add the following lines to your script (see Introduction to Linux Session 1 Exercise 4 for a refresher on writing and appending to files):

```bash
#!/bin/bash
echo "Hello, CCRI!"
```  

>[!TIP]
>To navigate back one directory, you can use the command `cd ..`. To navigate back to your home directory, you can use the command `cd ~`. To navigate to the previous location, you can use `cd -`.
  
**You are done when**:  

- You have successfully created a new directory called `scripts` and a new bash script called `hello_ccri.sh` inside it.  

## 2. Exercise 2: Running a simple `.sh` script, redirection, and piping

**Goal:** Learn how to run a simple `.sh` script, redirect output to a file, and pipe output to another command.  

Now that you have refreshed your knowledge of how to assemble a simple script, let's run it on Linux. You should already be familiar with basic Bash scripting.  

1. Run the script from the command line using the following command:

```bash
bash hello_ccri.sh
```

You should observe the output printed to the terminal:

```bash
Hello, CCRI!
```

> [!IMPORTANT]
> What happens if you try to execute the script with `./hello_ccri.sh` and why? How do you fix it?

2. Now, redirect the output of the script to a new file called `hello_ccri_output.txt` using the following command:

```bash
bash hello_ccri.sh > hello_ccri_output.txt
```

`cat` the contents of the new file to verify that the output was redirected correctly:

```bash
cat hello_ccri_output.txt
# Hello, CCRI!
```

3. Now, pipe the output of the script to the `wc` command to count the number of lines, words, and characters in the output:

```bash
bash hello_ccri.sh | wc
```

You should see this output:

```bash
1       2      13
```

which indicates that there is 1 line, 2 words, and 13 characters in the output.  

> [!TIP]
> You can also run `bash hello_ccri.sh | wc -l` to only see the number of lines.

**You are done when**:  

- You have run your `hello_ccri.sh` script and observed the expected output.  
- You have redirected the output of your script to a new file called `hello_ccri_output.txt` and verified that the output was redirected correctly.  
- You have piped the output of your script to the `wc` command and observed the expected output.  

## 3. Exercise 3: Running a simple scientific computing script

Finally, we get to the fun part! Let's run a simple scientific computing script. This script will view the first ten lines of a gzipped fastq file and count the number of reads in the file.  
  
1. First, we need to understand what the script is doing. It is a bad idea to run a script without understanding its contents! Inspect the contents of the script using the `cat` command:

```bash
cd ../
cat print_and_count_reads.sh
```

You should see the following output:

```bash
#!/bin/bash

FASTQ_FILE="../example_data/fastq/SRR7890883.chr17_50k_R1.fastq"

echo "First ten lines of the fastq file:"
cat "$FASTQ_FILE" | head -n 10

echo "Counting the number of reads in the fastq file:"
cat "$FASTQ_FILE" | wc -l | awk '{print $1/4}'
```

Can you figure out what each line of the script is doing?  

For spoilers, see below.  

```bash
#!/bin/bash                                                                               # This line specifies that the script should be run using the bash shell.

FASTQ_FILE="../example_data/fastq/SRR7890883.chr17_50k_R1.fastq"           # This line assigns the file path to a variable

echo "First ten lines of the fastq file:"                                                 # This line prints a message to the terminal indicating that the first ten lines of the fastq file will be displayed.
cat "$FASTQ_FILE" | head -n 10                       # This line uses the `cat` command to concatenate the `.fastq` file in the example data dir, then pipes the output to the `head` command, which displays the first ten lines of the file.

echo "Counting the number of reads in the fastq file:"                                    # This line prints a message to the terminal indicating that the number of reads in the `.fastq` file will be counted.
cat "$FASTQ_FILE" | wc -l | awk '{print $1/4}'        # This line uses `cat` again to concatenate the `.fastq` file in the example data dir, then pipes the output to the `wc -l` command, which counts the number of lines in the file. Since each read in a `.fastq` file is represented by four lines, the output is then piped to `awk`, which divides the line count by 4 to get the number of reads.
```

2. Now that you understand what the script is doing, let's run it.  

```bash
bash print_and_count_reads.sh
```

You should see the following output:

```bash
First ten lines of the fastq file:
@SRR7890883.5485
CCCACCTTCCACCCAGCCGCAGTACCCGGCAGCTTCAGCCACTTGGGCACCTTGCCCAGGCTCCTCTTCACGGGCTGGGCCGTCCCTGGGATGGGCTCAGGGGGGACCAGCGCCCCCTCCTCAGC
+
AAFFFKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKFKKKKKKKKKKKKKKKKFKFAFFKKKFKKKKKKKKKKKKKKKKKKKKKK
@SRR7890883.5770
GTCTGACTTCCCAGGGACCGAGGATTCACCTGTGGTTGATGATGCGGTGGACGGTCATCCACTCTGGCTTGATGCCAAAACGATAGTACTTCTCCTCCATCTCAGCATAGTGCGGGTCTTTCACT
+
AAFFFKKKKKKKKKKKKKKKKKKKKKKKKKKKKFKKKFKKKKKKKKKKKKKKFKKKKKKKKKKKKKKKKKKKKKKKKKFFKKKKKKFKKKKKKKKKKKKKKKKKKKKKKKKKKKFFAFKKKKKKK
@SRR7890883.6193
CACATATAGTGTCATGTATGGTCTCCACATGTGAGAGCACGAGGGCATCTTGTGTAAGTGCTGCCTATGGGTAGAGAGCAGTGTGGGGATGTACTCATGGGTCTGAGTGCCCACGAGAGGAGGTG
Counting the number of reads in the fastq file:
50000
```

**You are done when**:  

- You have successfully run `print_and_count_reads.sh, you observed the expected output, and you understand why.

**Extension - if you finish early:**

Try running:

```bash
bash -x print_and_count_reads.sh
```

What's different? Can you explain what's happening?

## Exercise 4: Environment management using conda  

**Goal:** Learn how to create and manage isolated environments using Conda.  

So far, we have been using simple shell commands and scripts to run our analyses. However, as we start to work on more complex projects, we will need to use different software packages and libraries, especially when manipulating scientific data file types such as `.fastq`, `.bam`, and `.vcf`.  

If you are working on several projects, you may want to use the same (or different) versions of the same software for each project. This is where Conda comes in handy. Conda is a package manager that allows you to create isolated "environments" for your projects, each with its own set of dependencies. Using Conda also allows you to more easily share the exact software versions (environment) with others, ensuring analysis reproducibility. It also makes it easier to install all software dependencies with minimal effort.

> [!TIP]
> It is good practice to create a new Conda environment for each project you work on and keep track of the installed software versions.  

Follow these steps to set up conda:  

1. Download `miniconda`

`wget https://repo.anaconda.com/miniconda/Miniconda3-py314_26.5.3-2-Linux-x86_64.sh`

> [!NOTE]
> [`miniconda`](https://www.anaconda.com/docs/getting-started/concepts/anaconda-or-miniconda) is an alternative `conda` installed with much smaller space requirements.

2. Install `miniconda`

`bash Miniconda3-py314_26.5.3-2-Linux-x86_64.sh`

Follow the prompts: Enter > yes > Enter > yes (be sure to type `yes` at the last prompt asking you `Do you wish to update your shell profile to automatically initialize conda?`)

Restart your terminal.

Once done, open a new terminal to make the Conda installation "visible" to the terminal.  You should see `(base)` at the very beginning of the command prompt.

>[!NOTE]
>If something goes wrong, you can uninstall the Miniconda installation with
>
>```bash
>conda deactivate # Make sure your base Conda environment is deactivated
>~/miniconda3/uninstall.sh # Uninstall miniconda; This assumes you used the default installation location
>```

3. Add channels to your Conda installation. Channels are the channels (=locations) where Conda looks for packages. The default channel is the Anaconda channel, but there are many other channels available, such as conda-forge and bioconda, which have a wider range of bioinformatics packages. To add these channels, run the following commands (the order in which you add channels matters):

```bash
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --show channels # Verify the channel list
```

You should get the following output: 

```bash
channels:
  - conda-forge
  - bioconda
  - defaults
```

4. Now, let's create a new conda environment for our project. We will call this environment `intro_to_sci_comp`. To create the environment, run the following command:  

```bash
conda create -n intro_to_sci_comp python=3.10 conda-forge::numpy=2.2.6
```

We specify that we want to create an environment with Python 3.10 and `numpy=2.2.6` (from the channel `conda-forge`) pre-installed.

> [!IMPORTANT]
> Notice that we specify the exact Python version (`3.10`) when setting up the environment (for Python, the first two version numbers are sufficient, and additional subversions don't introduce any major changes). Using an exact software version is the only way to have your results reproducible.

> [!NOTE]
> Notice we used `::` to specify which Conda channel to use for `numpy` installation. This way, you can overwrite the existing list of channels and use a **specific** channel to install the package. This is recommended as it further increases the reproducibility.

5. To activate the environment, run the following command:  

```bash
conda activate intro_to_sci_comp
```

6. To install new packages in the environment, run the following command:  

```bash
conda install <package_name>
```

You can add multiple packages by separating them with spaces. You can also specify the channel from whcih the package should be installed with `<channel>::<package_name>`, and you can specify the version of the package you want to install by appending `=<version>` to the package name. 

It is **strongly** recommended to install all the software and packages at once. Conda attempts to find an optimal combination of dependencies, which is only possible if it knows everything it should consider at once. **Avoid installing them individually.** Conda would eventually fail due to conflicting dependencies if you install software one at a time.

Use the `check_numpy_version.py` script to check if it works in the new conda environment.  

```bash
conda activate intro_to_sci_comp
python check_numpy_version.py
# 2.2.6
```

7. To ensure full reproducibility, you can export the list of packages installed in your conda environment to a `yaml` file. This file can be used to recreate the environment on another system. To export the environment, run the following command:  

```bash
conda env export > intro_to_sci_comp.yaml
```

You should be able to spot your `python` and `numpy` packages, as well as the other dependencies that were automatically installed. At the top of the file, you should see the name of the environment and the version of conda that was used to create it.  

> [!TIP]
> Using `conda env export` includes system-specific "builds". These are not software versions _per se_ and don't change the software functionality. Reproducing the Conda environment on a **different** server using this export is unlikely to work. To only record the software versions, use:
> 
> ```bash
> conda env export --no-builds > intro_to_sci_comp.yaml
> ```

`--no-builds` option is an optimal balance between keeping track of the exact software versions while being able to share the environment with people using a different cluster.

9. To deactivate your conda enironment and return to the base environment, run the following command:  

```bash
conda deactivate
```

10. To create an environment from a `yaml` file, we will use the provided `.yaml` that will create the environment we need for the following session. Run the following command:  

```bash
conda env create -f somatic_variant_calling.yaml
```

When the environment is created, you should be able to see the `somatic_variant_calling` environment in the list of conda environments on your system. You can check this by running the following command:  

```bash
conda env list
```

Using a Conda environment YAML is the most efficient way to record and share software versions and overall setup. It is also very easy to use version control using git.  

> [!NOTE]
> git version control will be covered in one of the future courses.

You can list all the installed tools in this environment

```bash
conda list -n somatic_variant_calling
```

>[!IMPORTANT]
>You will need the `somatic_variant_calling` environment in Session 2, so please only **STOP** your CodeSpace and do not delete it.  

How do the output software versions compare to the original environment YAML file [`somatic_variant_calling.yaml`](./somatic_variant_calling.yaml)?  

Here are some useful commands for managing conda environments:  

| Command | Description |
|---------|-------------|
| `conda create -n <env_name> <package1> <package2> ...` | Create a new conda environment with the specified packages installed. |
| `conda env create -f <environment.yaml>` | Create a new conda environment from a `yaml` file. |
| `conda activate <env_name>` | Activate a specific conda environment. |
| `conda install <package_name>` | Install a package in the current conda environment. |
| `conda remove <package_name>` | Remove a package from the current conda environment. |
| `conda env export > environment.yaml` | Export the list of packages in the current conda environment to a `yaml` file. |
| `conda env export --no-builds > environment.yaml` | Export the list of packages in the current conda environment to a `yaml` file, but without system builds. |
| `conda deactivate` | Deactivate the current conda environment and return to the base environment. |
| `conda env list` | List all of your conda environments on the system. |
| `conda remove -n <env_name> --all` | Remove a conda environment and all of its packages. |
| `conda list` | List all packages installed in the current conda environment. |
| `conda list -n <env_name>` | List all packages installed in the `<env_name>` conda environment. |
| `conda clean -a` | Clean up unused packages and caches to free up space. |

**You are done when:**

- You have installed Miniconda.  
- You have created a new environment called `intro_to_sci_comp` with Python 3.10 and numpy 2.2.6 installed.  
- You have successfully run the `check_numpy_version.py` script.  
- You have exported the list of packages in the `numpy` environment to a `yaml` file.  
- You have deactivated the `numpy` environment and returned to the base environment.  
- You have created a new environment called `somatic_variant_calling` from the provided `somatic_variant_calling.yaml` file and verified the software versions.  

## 5. Optional - Exercise 5: Activating a Conda environment in a script

Sometimes, you may want to run a script that runs a specific software, and therefore requires a Conda environment to be activated. However, you cannot just use `conda activate <env_name>` in a script because the `conda` command might not be available in non-interactive shells. You have to make the shell aware of your Conda installation. This can be done by sourcing the `conda.sh` script. You can then activate the environment in the script and use the installed software.  

You can add this to the top of your script (but below `#!/bin/bash`):  

```bash
conda_env_name="example_env"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"
```

Try this out for yourself - create a new job script called `check_numpy_version_script.sh` which activates the `intro_to_sci_comp` environment and then runs the `check_numpy_version.py` script.  

>[!NOTE]
>When you submit the script, you must have your `base` conda environment activated. If you have another environment activated, the job will fail because the job script will not be able to find the conda environment.  

Example script:  

```bash
#!/bin/bash

conda_env_name="intro_to_sci_comp"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"

python3 check_numpy_version.py
```

**You are done when:**

- You have successfully run the `check_numpy_version.py`non-interactively by activating the `intro_to_sci_comp` conda environment in a `.sh` script.  

> [!NOTE]
> The provided Conda activation code chunk only works if you install Conda as described in this tutorial. It will likely not work if you used regular [Conda/Anaconda](https://www.anaconda.com/download), [Mamba/Miniforge](https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html), or [Micromamba](https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html) (the other two alternative installers).


## End of Session 1

Well done, you have made it to the end of the session! You can now run simple commands and scripts on a Linux machine, and you have learned how to create and manage isolated environments using Conda. See you in Session 2 to run a variant calling pipeline!  

>[!IMPORTANT]
>You will need the `somatic_variant_calling` environment in Session 2, so please only **STOP** your CodeSpace and do not delete it.  
