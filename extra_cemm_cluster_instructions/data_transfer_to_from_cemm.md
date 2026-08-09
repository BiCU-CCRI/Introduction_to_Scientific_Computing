# Data transfer to/from the CeMM cluster/Isilon  

Now that you have started to produce results on the CeMM cluster, you need a reliable way to transfer data to and from the CeMM cluster from Isilon. It may be tempting to use the Finder once you have mounted `nobackup` and `research`, but this is not a reliable way to transfer data.  

We recommend using `rsync` for data transfer. The `rsync` program is a fast and versatile file copying tool that can copy files locally or to/from a remote host. It is widely used for data transfer because it can resume interrupted transfers, preserve file permissions and timestamps, and transfer only the differences between files.  

`rsync -avhP <source> <destination>` is the recommended command for transferring data from Isilon to `nobackup` or `research`. The arguments mean:

- `-a`: archive mode: recursive, preserves symbolic links, file permissions, user & group ownerships, and timestamps
- `-v`: verbose, print information about the transfer
- `-h`: human-readable, print sizes in a human-readable format
- `-P`: show progress during transfer and keep partially transferred files

Let's try it with an example file. Navigate to one of your folders on Isilon using the `011Sv123` server, and make an example file. Then, transfer this file to the `session_4` directory on the CeMM cluster using the `rsync` command.  

>[!TIP]
>Always run a dry run of the `rsync` command first to see what files will be transferred. You can do this by adding the `--dry-run` argument to the command.  

>[!NOTE]
>Be careful about the `<source>` and `<destination>` arguments. The `rsync` command will copy files from the `<source>` to the `<destination>`. If you get these arguments wrong, you may end up overwriting files on the CeMM cluster or Isilon. When you end a path with a forward slash `/`, it means "copy the contents of this directory", whereas if you don't end with a slash, it means "copy this directory and its contents".
>For example:
>`rsync -r /path/to/source/ /path/to/destination/` will copy the contents of the `source` directory to the `destination` directory, whereas
>`rsync -r /path/to/source /path/to/destination/` will copy the `source` directory and its contents to the `destination` directory.

```bash
touch /mnt/bioinformatics/Research/<your_lab_name>/Internal/<your_username>/<your_favourite_isilon_folder>/hello_cemm.txt  

echo "Hello CeMM!" > /mnt/bioinformatics/Research/<your_lab_name>/Internal/<your_username>/<your_favourite_isilon_folder>/hello_cemm.txt  

rsync -avhP --dry-run /mnt/bioinformatics/Research/<your_lab_name>/Internal/<your_username>/<your_favourite_isilon_folder>/hello_cemm.txt <cemm_username>@login.int.cemm.at:/nobackup/<lab_name>/<user_name>/<your_favourite_nobackup_folder>/ 

# <enter your CeMM username and password when prompted>

# sending incremental file list
# hello_cemm.txt

# sent 59 bytes  received 19 bytes  156.00 bytes/sec
# total size is 13  speedup is 0.17 (DRY RUN)

rsync -avhP /mnt/bioinformatics/Research/<your_lab_name>/Internal/<your_username>/<your_favourite_isilon_folder>/hello_cemm.txt <cemm_username>@login.int.cemm.at:/nobackup/<lab_name>/<user_name>/<your_favourite_nobackup_folder>/

# sending incremental file list
# hello_cemm.txt
#              13 100%    0.00kB/s    0:00:00 (xfr#1, to-chk=0/1)

# sent 112 bytes  received 35 bytes  294.00 bytes/sec
# total size is 13  speedup is 0.09
```
