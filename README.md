# Introduction to Scientific Computing

The Introduction to Scientific Computing course is for CCRI users who want to learn how to utilize the computational infrastructure (the CeMM cluster) to analyze scientific data.

## Session Contents

Below you can find a description of the topics that will be covered in each session.

### Session 1

1. Exercise 1: Logging onto a computing cluster using SSH  
2. Understanding the CeMM cluster architecture  
3. Understanding the CeMM cluster file storage systems  
4. Exercise 2: Mounting `/nobackup` and `/research` on a laptop  
5. Exercise 3: Running simple commands using the command line on a login node  
6. Exercise 4: Running a simple `.sh` script on a login node  
7. Exercise 5: Running a simple scientific computing script on a login node

### Session 2

1. Exercise 1: Learning when to use a compute node instead of a login node  
2. SLURM basics  
3. SLURM directives  
4. SLURM queues  
5. Exercise 2: Using `srun` to start an interactive job  
6. Exercise 3: Running simple commands and scripts using the command line on a compute node via an interactive job  
7. Exercise 4: Running a simple `.sbatch` script on a compute node  
8. Exercise 5: Useful commands to track cluster usage and job status  

### Session 3

1. Exercise 1: Environment management using the module system  
2. Exercise 2: Environment management using conda
3. Exercise 3: Putting it all together: somatic short variant calling analysis  

### Session 4 (CeMM cluster access required)

1. Exercise 1: Data transfer to/from the CeMM cluster/Isilon  
2. Exercise 2: Running an RStudio session on the CeMM cluster  

## Prerequisites

### Required pre-requisites

- Intro to Linux (or pre-existing basic knowledge of Linux commands and bash scripting)
  
### Recommended pre-requisites

- CeMM cluster account  
  If you don't have one, you can still take Sessions 1-3, but you might want to skip Session 4 which is tailored specifically to CeMM cluster users.  

If you have a CeMM cluster account:  

- Visual Studio Code (VSCode)  
  Newer versions are incompatible with the CeMM cluster so we recommend downloading **version 1.85.2** as a portable version by following the instructions at [https://code.visualstudio.com/docs/supporting/faq#_previous-release-versions](https://code.visualstudio.com/docs/supporting/faq#_previous-release-versions)

- "Remote - SSH" extension enabled on VSCode  
  This extension is required to connect to the CeMM cluster - please install and enable it in your VSCode by following these instructions:
  1. Navigate to the "Extensions" tab in VSCode (`Ctrl + Shift + X` on Windows; `Cmd + Shift + X` on Mac)  
  2. Search for "Remote - SSH"
  3. Click "Install"  

## A guide to GitHub Codespaces

For Sessions 1 and 2, we will use Github Codespaces to provide a cloud-based Linux environment that allows you to run code in a virtual machine. You can access it through your web browser, and it provides a similar experience to using the CeMM cluster.

### Setting up GitHub Codespaces

1. Scroll back to the top of this GitHub repo.
2. Click the green **Code** button.
3. Select the **Codespaces** tab.
4. Click **Create codespace on main**.
5. Wait for the environment to build - this can take a few minutes the first time.

################# pic #################

Once it is ready, you will have a complete Linux environment running in your browser, including a terminal where you can run commands.

You can experiment freely in this environment — if something goes wrong, you can always restart the Codespace or return to the original course files. It doesn't have access to your local files, so don't be afraid to play around.

### Managing GitHub Codespaces

> [!NOTE]
> GitHub Codespaces is free for individual users within the included monthly usage allowance (currently up to 60 hours per month). This should be sufficient to complete this introductory course. If you leave your Codespace open or stop working for the day, it will automatically stop after 30 minutes of inactivity. Your files will be saved, and you can restart the Codespace when you return.

> [!TIP]
> **When you have finished using Codespaces:** Remember to delete your Codespace if you no longer need it. Codespaces that are left unused can continue to count towards your storage and usage limits. You can always create a new Codespace from this repository again in the future if needed.

You can view and manage your Codespaces at [https://github.com/codespaces](https://github.com/codespaces). Click the `...` options menu next to a Codespace. There you can find options to stop or delete it. Remember, stopping pauses the environment while keeping your work. Delete a Codespace only when you have finished with it.

############################## pic ##############################

## A guide to LearnSlurm

For Sessions 2 and 3, we will use [LearnSlurm](https://learnslurm.com/index), a free online platform that allows you to practice using SLURM commands in a simulated environment. It provides a virtual cluster where you can submit jobs, manage queues, and learn SLURM commands without needing access to the CeMM cluster.  

### Setting up LearnSlurm

1. Go to [https://learnslurm.com/index](https://learnslurm.com/index)

2. Select "> Launch Trainer" to start the SLURM training environment.  

You now have a fake high-performance computing cluster running in your browser, including a terminal where you experiment with common SLURM commands. Similarly to Codespaces, LearnSlurm also doesn't have access to your local files, so you can play around without being worried about deleting anything by accident.  

The downside of LearnSlurm is that it doesn't actually run jobs, but rather simulates their running. This means that you won't be able to see the output of commands that require actual computation, but you will still be able to practice using SLURM commands to submit and track jobs.  
