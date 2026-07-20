# Introduction to Scientific Computing

The Introduction to Scientific Computing course is for CCRI users who want to learn how to utilize the computational infrastructure (the CeMM cluster) to analyze scientific data.

### Required pre-requisites:
- Intro to Linux (or pre-existing basic knowledge of Linux commands and bash scripting)
  
### Recommended pre-requisites:
- CeMM cluster account  
  If you don't have one, you can still take the course, but you will be limited to watching during the interactive parts.

- Visual Studio Code (VSCode)  
  Newer versions are incompatible with the CeMM cluster so we recommend downloading **version 1.85.2** as a portable version by following the instructions at [https://code.visualstudio.com/docs/supporting/faq#_previous-release-versions](https://code.visualstudio.com/docs/supporting/faq#_previous-release-versions)
    
- "Remote - SSH" extension enabled on VSCode  
  This extension is required to connect to the CeMM cluster - please install and enable it in your VSCode by following these instructions:
  1. Navigate to the "Extensions" tab in VSCode (`Ctrl + Shift + X` on Windows; `Cmd + Shift + X` on Mac) 
  2. Search for "Remote - SSH"
  3. Click "Install"  

## Session Contents

Below you can find a description of the topics that will be covered in each session.

### Session 1
- Logging onto the CeMM cluster
- Learning about different node types available on the cluster
- Learning about the file storage systems on the CeMM cluster - `/nobackup` and `/research`
- Mounting `/nobackup` and `/research` on a laptop
- Running simple commands using the command line on a login node
- Running simple `.sh` scripts on a login node

### Session 2 
- Learning when to use a compute node instead of a login node
- SBATCH directives
- SLURM queues
- Using `srun` to start an interactive job
- Running simple commands using the command line on a compute node via an interactive job
- Running a simple `.sbatch` script on a compute node
- Useful commands to track cluster usage and job status

### Session 3
- Environment management using the module system
- Environment management using conda
- Data transfer to/from the CeMM cluster/Isilon
- Putting it all together: running an RStudio session on the CeMM cluster
- Putting it all together: somatic short variant calling analysis
