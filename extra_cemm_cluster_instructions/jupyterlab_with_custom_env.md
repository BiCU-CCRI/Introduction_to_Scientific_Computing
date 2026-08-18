# Running JupyterLab using your own conda environment on the CeMM cluster

Sometimes you have a specific environment that you want to use for your analysis, which might include some specialist software that is not included in the pre-configured JupyterLab module. In this case, you can create your own conda environment and run JupyterLab using that environment.  

1. Activate your conda environment.  

2. Install the following packages in your environment:  

```bash
conda install jupyterlab=4.6.2 plotly=6.9.0 matplotlib=3.10.9 pandas=2.3.3
```

1. Check that `ipykernel` is installed in your environment - it is a dependency of `jupyterlab` so should be installed automatically when you install `jupyterlab`. If not, install it too.  

```bash
conda list ipykernel
```

1. To add your environment as a kernel, run the following command.

```bash
python -m ipykernel install --user --name <env_name> --display-name "<env_name>"
# Installed kernelspec <env_name> in /home/<username>/.local/share/jupyter/kernels/<env_name>
```

1. Now, check the contents of the `jupyterlab_customenv.sbatch` script. This script is similar to the `jupyterlab.sbatch` script, but it activates your conda environment, and runs `jupyterlab` using the version installed in your environment as opposed to the module version.  

```bash
#!/bin/bash
#SBATCH --partition=interactiveq
#SBATCH --qos=interactiveq
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=12:00:00
#SBATCH --job-name=jupyter-lab
#SBATCH --output=jupyter-lab-%j.log

conda_env_name="<env_name>"
echo "Activating environment"
source "${CONDA_PREFIX}/etc/profile.d/conda.sh"
conda activate "${conda_env_name}"

port=$(shuf -i8000-9999 -n1)
node=$(hostname).int.cemm.at
user=$(whoami)
host ${node}

jupyter lab --no-browser --port=${port} --ip=${node}
```

1. Submit the `jupyterlab_customenv.sbatch` to SLURM, and click the link in the output to access the Jupyter Notebook session in your web browser.  

2. To set your own environment as the kernel, click the `Kernel` menu, then `Change kernel`, and select your environment from the list. You should now be able to use Jupyter Notebook in your web browser with your own conda environment!  
