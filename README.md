# Introduction to Scientific Computing

The Introduction to Scientific Computing course is for St. Anna CCRI users who want to learn how to utilize the computational infrastructure (the CeMM cluster) to analyze scientific data.

## Session Contents

Below you can find a description of the topics that will be covered in each session.

### Session 1 – Shell, scripts, and environments (Codespaces)

1. Exercise 1: Running simple commands using the command line  
2. Exercise 2: Running a simple `.sh` script, redirection, and piping  
3. Exercise 3: Running a simple scientific computing script  
4. Exercise 4: Environment management using Conda
5. Exercise 5: Activating a Conda environment in a script  
6. TODO: Project organization and file conventions (?)
7. TODO: Data/metadata provenance                  (?)
 
### Session 2 – Variant calling (Codespaces)

- Intro to sequencing data formats used in this training (fastq, bam, vcf)  
- Read QC and trimming  
- Alignment  
- Variant calling  
- Filtering and sanity checks  
 
### Session 3 – SLURM basics (LearnSlurm)

- Why resource managers exist on shared clusters  
- SLURM directives  
- SLURM queues  
- Submitting and monitoring jobs (`sbatch`, `salloc`, `srun`, `squeue`, `sacct`)  
- Cancelling jobs (`scancel`)  
- Tracking job usage (`seff`)  
 
### Session 4 – Variant calling and interactive work on the CeMM cluster (CeMM cluster)

- Logging into the CeMM cluster  
- Navigating the CeMM filesystem  
- Environment management using the module system  
- Converting `.sh` scripts into `.sbatch` scripts  
- Running the variant calling pipeline on the CeMM cluster  
- Interactive work: interactive sessions, RStudio, and JupyterLab on the CeMM cluster  
- Wrap-up  

## Prerequisites

### Required pre-requisites

- Intro to Linux (or pre-existing basic knowledge of Linux commands and bash scripting)
 - [GitHub](https://github.com/signup) account (free) with enough Codespaces (minimum of 20 hours usage left)
### Recommended pre-requisites

- CeMM cluster account  
  If you don't have one, you can still take Sessions 1-3, but you might want to skip Session 4, which is tailored specifically to CeMM cluster users. If you don't have a CeMM cluster account, you can also join somebody who does and go through Session 4 together. We **recommend joining Session 4,** even if you don't have a CeMM cluster account, to get a full overview of the process for working at the CeMM cluster. 

If you have a CeMM cluster account:  

- Visual Studio Code (VSCode)  
  Newer versions are incompatible with the CeMM cluster so we recommend downloading **version 1.100.3** as a portable version by following the instructions at [Working on the CeMM cluster Analytics/Tips and practical information/VS Code/Supported VS Code versions](https://confluence.ccri.at/spaces/BiKB/pages/119799933/Tips+and+practical+information#Tipsandpracticalinformation-SupportedVSCodeversions)

- "[Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)" extension enabled on VSCode  
  This extension is required to connect to the CeMM cluster - please install and enable it in your VSCode by following these instructions:
  1. Navigate to the "Extensions" tab in VSCode (`Ctrl + Shift + X` on Windows; `Cmd + Shift + X` on Mac)  
  2. Search for "Remote - SSH"
  3. Click "Install"  

## A guide to GitHub Codespaces

For Sessions 1 and 2, we will use Github Codespaces to provide a cloud-based Linux environment that allows you to run code in a virtual machine. You can access it through your web browser, and it provides a similar experience to using a Linux machine (e.g., the CeMM cluster). It doesn't require any additional software to be installed on your computer.

### Setting up GitHub Codespaces

1. Scroll back to the top of this GitHub repo.
2. Click the green **Code** button.
3. Select the **Codespaces** tab.
4. Click **Create codespace on main**.
5. Wait for the environment to build - this can take a few minutes the first time.

<img width="825" height="443" alt="codespaces_1" src="https://github.com/user-attachments/assets/4c0c86b3-6269-4efc-8bd7-84fe00bb9b4e" />


Once it is ready, you will have a complete Linux environment running in your browser, including a terminal where you can run commands. All participants have the same Linux environment, which makes it easier to share the code and go through the tutorials.

You can experiment freely in this environment — if something goes wrong, you can always restart the Codespace or return to the original course files. It doesn't have access to your local files, so don't be afraid to play around.  

### Managing GitHub Codespaces

> [!NOTE]
> GitHub Codespaces is free for individual users within the included monthly usage allowance (currently up to 60 hours per month). This should be sufficient to complete this introductory course. If you leave your Codespace open or stop working for the day, it will automatically stop after 30 minutes of inactivity. Your files will be saved, and you can restart the Codespace when you return.

You can view and manage your Codespaces at [https://github.com/codespaces](https://github.com/codespaces). Click the `...` options menu next to a Codespace. There you can find options to stop or delete it. Remember, **stopping** pauses the environment while keeping your work. 

**When you have finished using Codespaces:** Remember to delete your Codespace if you no longer need it. Codespaces that are left unused can continue to count towards your storage and usage limits. You can always create a new Codespace from this repository again in the future if needed.

<img width="1160" height="543" alt="codespaces_2" src="https://github.com/user-attachments/assets/9d0670fb-ee8b-48ec-84ff-c92f96172610" />

>[TIP!]
>Stopping the Codespace before going for lunch can save you 30 minutes of free allocated usage. Delete a Codespace only when you have finished with it.

## A guide to LearnSlurm

For Session 3, we will use [LearnSlurm](https://learnslurm.com/index), a free online platform that allows you to practice using SLURM commands in a simulated environment. It provides a virtual cluster where you can submit jobs, manage queues, and learn SLURM commands without needing access to the CeMM cluster.  

### Setting up LearnSlurm

1. Go to [https://learnslurm.com/index](https://learnslurm.com/index)

2. Select "> Launch Trainer" to start the SLURM training environment.

<img width="966" height="381" alt="learnslurm" src="https://github.com/user-attachments/assets/19e1916c-2db6-4358-ae22-0246071d1358" />


You now have a fake high-performance computing cluster running in your browser, including a terminal where you experiment with common SLURM commands. Similarly to Codespaces, LearnSlurm also doesn't have access to your local files, so you can play around without being worried about deleting anything by accident.  

The downside of LearnSlurm is that it doesn't actually run jobs, but rather simulates their running. This means that you won't be able to see the output of commands that require actual computation, but you will still be able to practice using SLURM commands to submit and track jobs.  
