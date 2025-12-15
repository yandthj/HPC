# Gila Filesystem Architecture Overview

## Home Directories: /home

/home directories are mounted as `/home/<username>`. Home directories are hosted under the user's initial /project directory. Quotas in /home are included as a part of the quota of that project's storage allocation

## Project Storage: /projects

Each active project is granted a subdirectory under `/projects/<projectname>`. This is where the bulk of data is expected to be, and where jobs should generally be run from. Storage quotas are based on the allocation award.

Quota usage can be viewed at any time by issuing a `cd` command into the project directory, and using the `df -h` command to view total, used, and remaining available space for the mounted project directory

## Scratch Storage: /scratch/username and /scratch/username/jobid

For users who also have Kestrel allocations, please be aware that scratch space on Gila behaves differently, so adjustments to job scripts may be necessary.

The scratch filesystem on Gila compute node is a 79TB spinning disk Ceph filesystem, and is accessible from login and compute nodes. The default writable path for scratch use is `/scratch/<username>`.

## Temporary space: $TMPDIR 

When a job starts, the environment variable `$TMPDIR` is set to `/scratch/<username>/<jobid>` for the duration of the job. This is temporary space only, and should be purged when your job is complete. Please be sure to use this path instead of /tmp for your tempfiles.

There is no expectation of data longevity in the temporary space, and is purged once a job has completed. If desired data is stored here during the job, please be sure to copy it to a /projects directory as part of the job script before the job finishes.

## Mass Storage System

There is no Mass Storage System for deep archive storage on Gila.

## Backups and Snapshots

There are no backups or snapshots of data on Gila. Though the system is protected from hardware failure by multiple layers of redundancy, please keep regular backups of important data on Gila, and consider using a Version Control System (such as Git) for important code. 
