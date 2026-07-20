# Introduction to Scientific Computing - Session 1  

Welcome to the Introduction to Scientific Computing course! This course is designed for CCRI users who want to learn how to utilize the computational infrastructure (the CeMM cluster) to analyze scientific data.  

## Logging onto a computing cluster using SSH  

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

### "Logging onto" a fake cluster for practice

If you do not have a CeMM cluster account or a terminal emulator for Windows, you a still join in!  

1. Navigate to [learn-slurm](https://learnslurm.com/trainer)

2. Click on "> Launch Trainer"

Now you can practice running simple commands on a computational cluster without needing a CeMM account. Still exciting.  

## Understanding the CeMM cluster architecture

The CeMM cluster is a high-performance computing environment that consists of multiple nodes, each with its own resources (CPU, memory, storage). The cluster is designed to handle large-scale computations and data analysis tasks.

When you first log in, you are on a *login node*. Login nodes are used for interactive tasks such as editing files, writing code, and submitting jobs. However, they are not meant for running long computations or resource-intensive tasks.

To run more computationally intensive jobs, you should use a *compute node*. Compute nodes are designed to handle heavy workloads and can be accessed by submitting jobs through a job scheduler (SLURM). We will go over SLURM and how to submit jobs to compute nodes in the next session.  

Here is an overview of the different node types available on the CeMM cluster:

####### pic from the sharepoint #######

## Understanding the file storage systems on the CeMM cluster

The CeMM cluster has two main file storage systems: `/nobackup` and `/research`. Each of these storage systems serves different purposes and has different characteristics.  

- `/research` : This is a backed-up file system used by the CeMM research groups for storing raw data only. As CCRI research groups, we will not use `/research` except in rare cases, since our main storage system is the Isilon file system hosted at the CCRI. 

- `/nobackup` : As the name suggests, this is a non-backed-up file system that is used for temporary storage of data and files while running analyses. This is the main file system that we will use as CCRI users. Each lab has a dedicated folder in `/nobackup` where they can store their data and files. The path to your lab's folder is `/nobackup/<lab_name>`.  

Let's take a look at what your lab already has in `/nobackup` by running the following command on the login node:

```bash
ls /nobackup/<lab_name>
```

### Storage quotas

Both `/nobackup` and `/research` have storage quotas that limit the amount of data that can be stored per group. The storage quota for `/nobackup` is ###### TB per lab, while the storage quota for `/research` is ###### TB per lab. 

Let's check how much storage your lab is currently using by running the following commands on the login node:

```bash
lfs quota -h -g <lab_name> /nobackup/
lfs quota -h -g <lab_name> /research/
```

Your group's data manager is in charge of making sure that the group does not exceed the storage quota. As a user, your main responsibility is to make sure that you regularly transfer your data back to Isilon for long-term storage. You should be aware that files stored in `/nobackup` may be deleted without warning, so it is doubly important to regularly back up important data to Isilon.  

## Mounting `/nobackup` and `/research` on a laptop

To access the files stored in `/nobackup` and `/research` from your local machine, you can "mount" these file systems using SSHFS (SSH File System). SSHFS allows you to mount a remote file system over SSH, making it accessible as if it were a local drive on your computer.  

### On a Mac

1. Open the Finder

2. Cmd + K to open the "Connect to Server" dialog

3. `smb://10.110.80.131` and click "Connect"

4. Enter your CeMM username and password when prompted

You should now see the `/nobackup` and `/research` directories in the Finder, and you can access your files as if they were on your local machine.

### On a Windows machine

1. Open the File Explorer

2. Right-click on "This PC" and select "Map network drive"

######## ??? need to test on a windows haha ########

## Running simple commands using the command line on a login node

Once you are logged onto the CeMM cluster, you can start running *simple* commands using the command line on a login node. You can use these on "learn-slurm" too.  

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
- `rm <file>` : Remove a file or directory *PROCEED WITH CAUTION ON NOBACKUP*

