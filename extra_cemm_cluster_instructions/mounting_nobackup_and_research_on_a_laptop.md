# Mounting `/nobackup` and `/research` on a laptop

**Goal:** Mount `/nobackup` and `/research` on your local machine for easier access to your files.  

To access the files stored in `/nobackup` and `/research` from your local machine, you can "mount" these file systems using SSHFS (SSH File System). SSHFS allows you to mount a remote file system over SSH, making it accessible as if it were a local drive on your computer.  

If you don't have a CeMM cluster account, you can skip this exercise and continue to the next one.  

### Mounting `/nobackup` and `/research` on a Mac

1. Open the Finder

2. Cmd + K to open the "Connect to Server" dialog

3. `smb://10.110.80.131` and click "Connect"

4. Enter your CeMM username (username@cemm.at) and password when prompted

You should now see the `/nobackup` and `/research` directories in the Finder, and you can access your files as if they were on your local machine.

### Mounting `/nobackup` and `/research` on Windows 

1. Open the File Explorer

2. Right-click on "This PC" and select "Map network drive"

3. `smb://10.110.80.131/nobackup` or `smb://10.110.80.131/research` and click "Enter"  

4. Enter your CeMM username (username@cemm.at) and password if prompted

**You are done when:**  

- You have successfully mounted `/nobackup` and `/research` on your local machine and can access your files from the Finder (Mac) or File Explorer (Windows).  
