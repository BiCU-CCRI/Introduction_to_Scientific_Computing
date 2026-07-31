# Introduction to Scientific Computing - Session 4  

Welcome to Session 4 of the Introduction to Scientific Computing course! For this session we will be focusing on running R and Jupyter Notebook from the CeMM cluster.  

## Overview
  
Today we'll cover:  

1. Exercise 1: Running a Jupyter Notebook session on the CeMM cluster 
2. Exercise 2: Running an RStudio session on the CeMM cluster 
3. Exercise 3: Data transfer to/from the CeMM cluster/Isilon  

## Exercise 1: Running a Jupyter Notebook session on the CeMM cluster  

**Goal:** Learn how to run a Jupyter Notebook session on the CeMM cluster.

Many scientists use Jupyter Notebook for data analysis and visualization. In this exercise, we will learn how to run a Jupyter Notebook session on the CeMM cluster. This allows you to undertake analyses which require more computational resources than your local laptop can provide.  

### Running Jupyterlab using the provided modules  

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

5. What if we try to install a package that's not included in the pre-configured Jupyterlab module? Try running cell 


### Running Jupyterlab using your own conda environment  

Sometimes you have a specific evironment that you want to use for your analysis, which might include some specialist software that is not included in the pre-configured Jupyterlab module. In this case, you can create your own conda environment and run Jupyterlab using that environment. We will demonstrate this with your `somatic_variant_calling` environment from session 3.  

1. Activate your `intro_to_sci_comp` conda environment.  

```bash
mamba activate intro_to_sci_comp
```

2. Install the `plotly` and `jupyterlab` packages in your environment:  

```bash
mamba install jupyterlab plotly
```

3. Check that `ipykernel` is installed in your environment - it is a dependency of `jupyterl`b so should be installed automatically when you install `jupyterl`. If not, install it too.  

```bash
mamba list ipykernel
```

4. To add your environment as a kernel, run the following command.

```bash
python -m ipykernel install --user --name intro_to_sci_comp --display-name "intro_to_sci_comp"
```

5. Now, check the contents of the `jupyterlab_customenv.sbatch` script. This script is similar to the `jupyterlab.sbatch` script, but it activates your conda environment, and runs `jupyterlab` using the version installed in your environment as opposed to the module version.  

```bash
#!/bin/bash
#SBATCH --partition=interactiveq
#SBATCH --qos=interactiveq
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=12:00:00
#SBATCH --job-name=jupyter-lab
#SBATCH --output=jupyter-lab-%j.log

conda_env_name="somatic_variant_calling"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"

port=$(shuf -i8000-9000 -n1)
node=$(hostname).int.cemm.at
user=$(whoami)
host ${node}

jupyter lab --no-browser --port=${port} --ip=${node}
```

5. Run the script, and click the link in the output to access the Jupyter Notebook session in your web browser. To set your own environment as the kernel, click the `Kernel` menu, then `Change kernel`, and select your environment from the list. You should now be able to use Jupyter Notebook in your web browser with your own conda environment!  

6. Let's test whether we can 

## Exercise 1: Running an RStudio session on the CeMM cluster  

**Goal:** Learn how to run an RStudio session on the CeMM cluster.  

Many scientists use R - specifically RStudio - for data analysis and visualization. In this exercise, we will learn how to run an RStudio session on the CeMM cluster. This allows you to underake analyses which require more computational resources than your local laptop can provide.  

>[TIP!]
>The BiCU have set up a [GitHub repository](https://github.com/BiCU-CCRI/running_rstudio_or_jupyterlab) specifically for running RStudio and Jupyter Notebook on the CeMM cluster. The scripts used in Session 4 are copied from this repository.

Let's start an RStudio session on the CeMM cluster.  

1. Log onto the CeMM cluster and navigate to your local copy of `Introduction_to_Scientific_Computing/session_4/rstudio/`.`

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

Can you find the line where we set the password? Feel free to change this if you like, but don't use anything sensitive.  

The script works by running an `apptainer` container with RStudio Server installed. It sets up a temporary directory for the RStudio session, configures the R environment, and starts the RStudio Server on a random port between 8000 and 9000 (these are the ports we can access from the CCRI network). The output of the script is a URL that you can use to access the RStudio session in your web browser.  

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

