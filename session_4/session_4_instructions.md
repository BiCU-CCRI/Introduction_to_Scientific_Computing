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

5. What if we try to install a package that's not included in the pre-configured Jupyterlab module? Try running section 6.  


### Running Jupyterlab using your own conda environment  

Sometimes you have a specific evironment that you want to use for your analysis, which might include some specialist software that is not included in the pre-configured Jupyterlab module. In this case, you can create your own conda environment and run Jupyterlab using that environment. We will demonstrate this with your `somatic_variant_calling` environment from session 3.  

1. Activate your `intro_to_sci_comp` conda environment.  

```bash
mamba activate intro_to_sci_comp
```

2. Install the following packages in your environment:  

```bash
mamba install jupyterlab==4.6.2 plotly==6.9.0 matplotlib==3.10.9 pandas==2.3.3
```

3. Check that `ipykernel` is installed in your environment - it is a dependency of `jupyterlab` so should be installed automatically when you install `jupyterlab`. If not, install it too.  

```bash
mamba list ipykernel
```

4. To add your environment as a kernel, run the following command.

```bash
python -m ipykernel install --user --name intro_to_sci_comp --display-name "intro_to_sci_comp"
# Installed kernelspec intro_to_sci_comp in /home/username/.local/share/jupyter/kernels/intro_to_sci_comp
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

conda_env_name="intro_to_sci_comp"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"

port=$(shuf -i8000-9000 -n1)
node=$(hostname).int.cemm.at
user=$(whoami)
host ${node}

jupyter lab --no-browser --port=${port} --ip=${node}
```

5. Submit the `jupyterlab_customenv.sbatch` to SLURM, and click the link in the output to access the Jupyter Notebook session in your web browser. 

6. To set your own environment as the kernel, click the `Kernel` menu, then `Change kernel`, and select `intro_to_sci_comp` from the list. You should now be able to use Jupyter Notebook in your web browser with your own conda environment!  

6. Let's test whether we can now run section 6 in `example_notebook.ipynb` which uses the `plotly` package (you need to run the whole notebook beforehand to process the inout data correctly). You should be able to produce the second plot at the end of the notebook now.  

**You are done when:**

- You have successfully started a Jupyter Notebook session on the CeMM cluster.
- You have successfully started a Jupyter Notebook session using your own conda environment.  
- You have produced the example plots using the `example_notebook.ipynb` notebook.  

## Exercise 2: Running an RStudio session on the CeMM cluster  

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

## Exercise 3 - Data transfer to/from the CeMM cluster/Isilon  

Now that you have started to produce results on the CeMM cluster, you need a reliable way to transfer data to and from the CeMM cluster from Isilon. It may be tempting to use the Finder once you have mounted `nobackup` and `research`, but this is not a reliable way to transfer data. We recommend using `rsync` for data transfer.  

To transfer data to/from the CeMM cluster, you will need to mount the `nobackup` and `research` partitions on the `011Sv123` server. This is a server that is accessible from both the CeMM cluster and Isilon. Once you have mounted the partitions, you can use `rsync` to transfer data between Isilon and the CeMM cluster.  

1. First, SSH into the CeMM cluster and note down your `cemm_uid` and `cemm_gid`. You can find these by running the following command:

```bash
id
```

2. In a new terminal window, SSH into the `011Sv123` server using your CCRI credentials:

```bash
ssh <firstname.lastname>@011Sv123.ad.ccri.at
# CCRI password
```

2. Mount the `nobackup` and `research` partitions to your home directory on the `011Sv123` machine.  

```bash
mkdir -p ~/cemm_nobackup
mkdir -p ~/cemm_research

sshfs -o uid=<cemm_uid> -o gid=<cemm_gid> <cemm_user>@10.110.81.2:/nobackup /home/<firstname.lastname>/cemm_nobackup
# CeMM password
sshfs -o uid=<cemm_uid> -o gid=<cemm_gid> <cemm_user>@10.110.81.2:/research /home/<firstname.lastname>/cemm_research
# CeMM password
```

3. Use the `rsync` command to transfer data between Isilon and the CeMM cluster. The `rsync` program is a fast and versatile file copying tool that can copy files locally or to/from a remote host. It is widely used for data transfer because it can resume interrupted transfers, preserve file permissions and timestamps, and transfer only the differences between files.  

### From Isilon to the CeMM fileshares

`rsync -rtvhP --no-g --no-o --no-p --chmod=u=rwX,g=rwX,o= <source> <destination>` is the recommended command for transferring data from Isilon to `nobackup` or `research`. The arguments mean:

- `-r`: recursive, copy directories and their contents
- `-t`: preserve modification times
- `-v`: verbose, print information about the transfer
- `-h`: human-readable, print sizes in a human-readable format
- `-P`: show progress during transfer and keep partially transferred files
- `--no-g`: do not preserve group ownership
- `--no-o`: do not preserve owner
- `--no-p`: do not preserve permissions
- `--chmod=u=rwX,g=rwX,o=`: set permissions to be readable and writable by the user and group, but not by others

Let's try it with an example file. Navigate to one of your folders on Isilon using the `011Sv123` server, and make an example file. Then, transfer this file to the `session_4` directory on the CeMM cluster using the `rsync` command.  

>[TIP!]
>Always run a dry run of the `rsync` command first to see what files will be transferred. You can do this by adding the `--dry-run` argument to the command.  

>[!NOTE]
>Be careful about the `<source>` and `<destination>` arguments. The `rsync` command will copy files from the `<source>` to the `<destination>`. If you get these arguments wrong, you may end up overwriting files on the CeMM cluster or Isilon. When you end a path with a backslash `\`, it means "copy the contents of this directory", whereas if you don't end with a backslash, it means "copy this directory and its contents".
>For example:
>`rsync -r /path/to/source/ /path/to/destination/` will copy the contents of the `source` directory to the `destination` directory, whereas
>`rsync -r /path/to/source /path/to/destination/` will copy the `source` directory and its contents to the `destination` directory.

```bash
cd /mnt/bioinformatics/Research/<your_lab_name>/Internal/<your_username>/<your_favourite_isilon_folder>
touch hello_cemm.txt
echo "Hello CeMM!" > hello_cemm.txt
rsync -rtvhP --no-g --no-o --no-p --chmod=u=rwX,g=rwX,o= --dry-run /mnt/bioinformatics/Research/<your_lab_name>/Internal/<your_username>/<your_favourite_isilon_folder>/hello_cemm.txt /home/<firstname.lastname>/cemm_nobackup/<lab_name>/<user_name>/Introduction_to_Scientific_Computing/session_4/

# sending incremental file list
# hello_cemm.txt

# sent 59 bytes  received 19 bytes  156.00 bytes/sec
# total size is 13  speedup is 0.17 (DRY RUN)

rsync -rtvhP --no-g --no-o --no-p --chmod=u=rwX,g=rwX,o= /mnt/bioinformatics/Research/<your_lab_name>/Internal/<your_username>/<your_favourite_isilon_folder>/hello_cemm.txt /home/<firstname.lastname>/cemm_nobackup/<lab_name>/<user_name>/Introduction_to_Scientific_Computing/session_4/

# sending incremental file list
# hello_cemm.txt
#              13 100%    0.00kB/s    0:00:00 (xfr#1, to-chk=0/1)

# sent 112 bytes  received 35 bytes  294.00 bytes/sec
# total size is 13  speedup is 0.09
```

### From the CeMM fileshares to Isilon

Now, we will modify the newly transferred file on the CeMM cluster, and transfer it back to Isilon.  

```bash
echo "Goodbye, CeMM!" >> /home/<firstname.lastname>/cemm_nobackup/<lab_name>/<user_name>/Introduction_to_Scientific_Computing/session_4/hello_cemm.txt
rsync -rtvhP --no-g --no-o --no-p --chmod=u=rwX,g=rwX,o= --dry-run /home/<firstname.lastname>/cemm_nobackup/<lab_name>/<user_name>/Introduction_to_Scientific_Computing/session_4/hello_cemm.txt /mnt/bioinformatics/Research/<your_lab_name>/Internal/<your_username>/<your_favourite_isilon_folder>/

# sending incremental file list
# hello_cemm.txt

# sent 53 bytes  received 19 bytes  144.00 bytes/sec
# total size is 28  speedup is 0.39 (DRY RUN)

rsync -rtvhP --no-g --no-o --no-p --chmod=u=rwX,g=rwX,o= /home/<firstname.lastname>/cemm_nobackup/<lab_name>/<user_name>/Introduction_to_Scientific_Computing/session_4/hello_cemm.txt /mnt/bioinformatics/Research/<your_lab_name>/Internal/<your_username>/<your_favourite_isilon_folder>/

# sending incremental file list
# hello_cemm.txt
#              28 100%    0.00kB/s    0:00:00 (xfr#1, to-chk=0/1)

# sent 121 bytes  received 35 bytes  312.00 bytes/sec
# total size is 28  speedup is 0.18
```

Although the file name is the same, since the contents have changed, `rsync` will transfer the file back to Isilon. You can check the contents of the file on Isilon to confirm that it has been updated.  

**You are done when:**

- You have successfully transferred a file from Isilon to the CeMM cluster using `rsync`.
- You have successfully transferred a file from the CeMM cluster to Isilon using `rsync`.  

## End of the course

Woohoo, you have completed the Introduction to Scientific Computing course! Enjoy using your new skills to analyze your data. If you have any questions or feedback, please reach out to the BiCU.  