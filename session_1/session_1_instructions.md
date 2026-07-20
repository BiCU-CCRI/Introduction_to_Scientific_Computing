# Introduction to Scientific Computing - Session 1  

Welcome to the Introduction to Scientific Computing course! This course is designed for CCRI users who want to learn how to utilize the computational infrastructure (the CeMM cluster) to analyze scientific data.  

## Overview
  
Today we'll cover:  
  
1. Exercise 1: Logging onto a computing cluster using SSH  
2. Understanding the CeMM cluster architecture  
3. Understanding the CeMM cluster file storage systems  
4. Exercise 2: Mounting `/nobackup` and `/research` on a laptop  
5. Exercise 3: Running simple commands using the command line on a login node  
6. Exercise 4: Running a simple `.sh` script on a login node  
7. Exercise 5: Running a simple scientific analysis script on a login node

This should be mostly a refresher of the topics covered in the "Introduction to Linux" course. The only difference is that this time you will be running commands on a computing cluster (or a pretend one if you don't have a CeMM account) instead of your local machine.  

## Exercise 1: Logging onto a computing cluster using SSH  

**Goal:** Learn how to log onto the CeMM cluster using SSH from a terminal or VSCode. If you don't have a CeMM cluster account, you can access a fake cluster using the "learn-slurm" website.

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

If you do not have a CeMM cluster account or a terminal emulator for Windows, you a still join in! We will use Codespaces, like we did in the Introduction to Linux course, to the login node of a computing cluster. You can use Codespaces to practice running simple commands and scripts on a pretend cluster without needing a CeMM account. Please review [README.md](README.md) for a detailed overview of Codespaces.    

1. Navigate to [https://github.com/BiCU-CCRI/Introduction_to_Scientific_Computing/tree/main](https://github.com/BiCU-CCRI/Introduction_to_Scientific_Computing/tree/main)

2. Click on the green "Code" button.

3. Select the "Codespaces" tab.

4. Click on the "Create codespace on main" button.  

5. Wait for the environment to build - this can take a few minutes the first time.  

Now you can practice running simple commands and scripts on a pretend computational cluster without needing a CeMM account. Still exciting.  

## Understanding the CeMM cluster architecture

The CeMM cluster is a high-performance computing environment that consists of multiple nodes, each with its own resources (CPU, memory, storage). The cluster is designed to handle large-scale computations and data analysis tasks.

When you first log in, you are on a **login node**. Login nodes are used for interactive tasks such as editing files, writing code, and submitting jobs. However, they are not meant for running long computations or resource-intensive tasks.

To run more computationally intensive jobs, you should use a **compute node**. Compute nodes are designed to handle heavy workloads and can be accessed by submitting jobs through a job scheduler (SLURM). We will go over SLURM and how to submit jobs to compute nodes in the next session.  

Here is an overview of the different node types available on the CeMM cluster:

###################### pic from the CeMM sharepoint ##########################

## Understanding the file storage systems on the CeMM cluster

The CeMM cluster has two main file storage systems: `/nobackup` and `/research`. Each of these storage systems serves different purposes and has different characteristics.  

- `/research` : This is a backed-up file system used by the CeMM research groups for storing raw data only. As CCRI research groups, we will not use `/research` except in rare cases, since our main storage system is the Isilon file system hosted at the CCRI. Some exceptions are for example adjunct PIs who may store raw data on `/research`, and shared resources provided by BiCU which are stored in `/research/lab_ccri_bicu/public`.

- `/nobackup` : As the name suggests, this is a non-backed-up file system that is used for temporary storage of data and files, for example while running analyses. This is the main file system that we will use as CCRI users. Each lab has a dedicated folder in `/nobackup` where they can store their data and files. The path to your lab's folder is `/nobackup/<lab_name>`.  

Let's take a look at what your lab already has in `/nobackup` by running the following command on the login node:

```bash
ls /nobackup/<lab_name>
```  

### Storage quotas

Both `/nobackup` and `/research` have storage quotas that limit the amount of data that can be stored per group. The storage quota for `/nobackup` is 24 TB per lab, while the storage quota for `/research` is 100 GB per lab member.  

Let's check how much storage your lab is currently using by running the following commands on the login node:

```bash
lfs quota -h -g <lab_name> /nobackup/
lfs quota -h -g <lab_name> /research/
```

Your group's data manager is in charge of making sure that the group does not exceed the storage quota. As a user, your main responsibility is to make sure that you regularly transfer your data back to Isilon for long-term storage. You should be aware that files stored in `/nobackup` may be deleted without warning, so it is doubly important to regularly back up important data to Isilon.  

## Exercise 2: Mounting `/nobackup` and `/research` on a laptop

**Goal:** Mount `/nobackup` and `/research` on your local machine for easier access to your files.  

To access the files stored in `/nobackup` and `/research` from your local machine, you can "mount" these file systems using SSHFS (SSH File System). SSHFS allows you to mount a remote file system over SSH, making it accessible as if it were a local drive on your computer.  

If you don't have a CeMM cluster account, you can skip this exercise and continue to the next one.  

### Mounting `/nobackup` and `/research` on a Mac

1. Open the Finder

2. Cmd + K to open the "Connect to Server" dialog

3. `smb://10.110.80.131` and click "Connect"

4. Enter your CeMM username and password when prompted

You should now see the `/nobackup` and `/research` directories in the Finder, and you can access your files as if they were on your local machine.

### Mounting `/nobackup` and `/research` on a Windows machine

1. Open the File Explorer

2. Right-click on "This PC" and select "Map network drive"

################################ ??? need to test on a windows haha #############################

## Exercise 3: Running simple commands using the command line on a login node

**Goal:** Learn how to run simple commands using the command line on a login node, create directories and files, and navigate the file system.  

Once you are logged onto the CeMM cluster, you can start running **simple** commands using the command line on a login node. You can use these in Codespaces too.  

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

To practice this, we will create a new directory in which to run the remaining analyses of this course.  
If you have already been working on the CeMM cluster and you already have a user directory in your lab folder in `/nobackup`, you can skip step 1.  
If you are using Codespaces, you can skip this exercise.  

1. If it doesn't exist yet, create your own user folder in `/nobackup`:

```bash
mkdir -p /nobackup/<lab_name>/<username>/
```

2. Navigate into your new directory.

```bash
cd /nobackup/<lab_name>/<username>/
```

3. Check that you are in the correct directory by running the `pwd` command. You should see the following output:

```bash
/nobackup/<lab_name>/<username>
```

How exciting, you have just made your own space on the CeMM cluster! You can now use this space to create working directories in which to run analyses.  

4. Clone this GitHub repository into your new user directory using the following command:

```bash
git clone https://github.com/BiCU-CCRI/Introduction_to_Scientific_Computing.git
```

This will create a new directory called `Introduction_to_Scientific_Computing` in your user directory, and download all the files from this GitHub repository into that directory.  

5. Navigate into the `Introduction_to_Scientific_Computing/session_1` directory using the `cd` command:

```bash
cd Introduction_to_Scientific_Computing/session_1/
```

Don't worry if you aren't familiar with `git` - this is the only git command we will use all course. If you want to get more familiar with `git`, you can take the "Introduction to Git" course that BiCU will soon be offering!
  
## Exercise 4: Running simple `.sh` scripts on a login node

Now that you have learned how to run simple commands on a login node, let's run a simple bash script using the login node. You should be familiar with bash scripting from Intro to Linux.  

### Running a simple bash script on a login node

1. Create a new file called `hello_ccri.sh` using the `touch` command:

```bash
touch hello_world.sh
```

5. Add the following lines to your script (see Introduction to Linux Session 1 Exercise 4 for a refresher on writing and appending to files):

```bash
echo '#!/bin/bash' > hello_ccri.sh
echo 'echo "Hello, CCRI!"' >> hello_ccri.sh
```  

6. Run the script from the login node using the following command:

```bash
bash hello_ccri.sh
```

You should observe the output printed to the terminal:

```bash
Hello, CCRI!
```

### Running a simple scientific computing script on a login node

Finally, we get to the fun part! Let's run a simple scientific computing script on a login node. This script will view the first ten lines of a gzipped fastq file and count the number of reads in the file. Since it isn't computationally intensive, we can safely run it on the login node without risking an angry email from CeMM IT.  

This exercise is a recap of part of `Introduction to Linux Session 4 Exercise 5: Piping the content of a compressed file`, except we will be executing the commands as a script instead of typing them into the command line.  
  
1. First, we need to understand what the script is doing. It is a bad idea to run a script without understanding its contents! Inspect the contents of the script using the `cat` command:

```bash
cat exercise_5.sh
```

You should see the following output:

```bash
#!/bin/bash

echo "First ten lines of the fastq file:"
zcat sample.fastq.gz | head -n 10

echo "Counting the number of reads in the fastq file:"
zcat sample.fastq.gz | wc -l | awk '{print $1/4}'
```

Can you figure out what each line of the script is doing?  

For spoilers, see below.  

```bash
#!/bin/bash                                                                   # This line specifies that the script should be run using the bash shell.

echo "First ten lines of the fastq file:"                                     # This line prints a message to the terminal indicating that the first ten lines of the fastq file will be displayed.
cat ./example_data/fastq/SRR7890883.chr17_50k_R1.fastq | head -n 10           # This line uses the `cat` command to concatenate the `.fastq` file, then pipes the output to the `head` command, which displays the first ten lines of the file.

echo "Counting the number of reads in the fastq file:"   # This line prints a message to the terminal indicating that the number of reads in the `.fastq` file will be counted.
zcat sample.fastq.gz | wc -l | awk '{print $1/4}'        # This line uses `cat` again to concatenate the `.fastq` file, then pipes the output to the `wc -l` command, which counts the number of lines in the file. Since each read in a `.fastq` file is represented by four lines, the output is then piped to `awk`, which divides the line count by 4 to get the number of reads.
```

2. Now that you understand what the script is doing, let's run it on the login node.  

```bash
bash exercise_5.sh
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
  
Well done, you have made it to the end of the session! You now know how to log onto the CeMM cluster, you understand the cluster architecture and file storage systems, you can mount the file systems on your local machine, you can run simple commands and scripts on a login node, and you an run a simple scientific computing script. See you in Session 2 to learn about using compute nodes and SLURM!
