# Installing conda on the CeMM cluster

1. Download miniconda

`wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`

2. Install miniconda

`bash Miniconda3-latest-Linux-x86_64.sh`

Follow the prompts, then restart your terminal.  

3. Add channels to your conda. Channels are the locations where conda looks for packages. The default channel is the Anaconda channel, but there are many other channels available, such as conda-forge and bioconda, which have a wider range of bioinformatics packages. To add these channels, run the following commands (the order in which you add channels matters):

```bash
conda config --add channels conda-forge
conda config --add channels bioconda
```

4. On the CeMM cluster, by default, packages are installed in the `home` directory, which is hosted on the `/research` partition. Since space on `/research` is limited, we will move our conda installation to the `/nobackup` partition.  

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
