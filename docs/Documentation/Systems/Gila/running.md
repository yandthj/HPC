# Running on Gila

*Learn about compute nodes and job partitions on Gila.*

## Login Nodes

In order to access Gila, you will need to login first to the Login Nodes. When you login, you will be taken to your home directory (/home/USER), and from there you can switch directory as needed to the projects filesystem or scratch filesystem. Please note, your home directory only has 25 GB of storage space available to it, and it is advised to store large files in a projects or scratch directory. 

Login nodes should be thought of as primarily being used for organization of files, submitting jobs, and initiating interactive node sessions. Login nodes should __NOT__ be used for executing applications or running large job processes - these actions will take up resources that other users need to use Gila, and could introduce system slowdown.

You can access the login nodes using the following addresses.

```
gila.hpc.nrel.gov
gila-login-1.hpc.nrel.gov
gila-hopper-login1.hpc.nrel.gov
```

## Compute Nodes

Compute nodes in Gila are single-threaded virtualized nodes. **These nodes are not configured as exclusive and can be shared by multiple users or jobs.** There are two sockets and NUMA nodes per compute node, with each socket containing 30 __AMD EPYC Milan__ (x86-64) cores. Each node has 220GB of RAM that can be used. Be sure to request the resources that your job needs, including memory and cores.


## GPU hosts

GPU nodes in Gila have NVIDIA A100 GPUs running on x86-64 __Intel Xeon Icelake CPUs__. There are 42 cores on a GPU node, with one socket and NUMA node. Each GPU node has 910GB of RAM, and each NVIDIA A100 GPU has 80GB of VRAM that can be used. Up to 8 NVIDIA A100 GPUs can be requested by the user.


## Grace Hopper hosts

There are 5 NVIDIA Grace Hopper nodes. To use the Grace Hopper nodes, submit your jobs to the gh partition from the `gila-hopper-login1.hpc.nrel.gov` login node. Each Grace Hopper node has a 72 core NVIDIA Grace CPU. The Grace-Hopper nodes are single socketed, with a single NUMA node region. Each Grace Hopper node has an NVIDIA GH200 GPU, with 96GB of VRAM and 480GB of RAM.

Please note - the __NVIDIA Grace CPUs__ run on a different processing architecture (ARM64) than both the __Intel Xeon Icelake CPUs__ (x86-64) and the __AMD EPYC Milan__ (x86-64) cores. Any application that is manually compiled by a user and intended to be used on the Grace Hopper nodes __MUST__ be compiled on the Grace Hopper nodes themselves. 

Accordingly, every job that is submitted to the Grace Hopper nodes __MUST__ be submitted from from the Grace Hopper login node (grace-hopper-login1.hpc.nrel.gov) in order to be successfully submitted and executed on the Grace Hopper Nodes.


## Partitions

A list of partitions can be found by running the `sinfo` command.  Here are the partitions as of 12/30/2025

| Partition Name                          | CPU |  GPU | Qty | RAM    | Cores/node |
| :--:                                    | :--:| :--: | :--:| :--:   | :--:       |                        
| gpu       |  Intel Xeon Icelake | NVIDIA Tesla A100-80 |  1  | 910 GB |   42            |      
| amd                                | 2x 30 Core AMD Epyc Milan | N/A |  36  | 220 GB |   60            |
| gh                                | NVIDIA Grace | GH200 |  5  | 470 GB |       72       |


## Performance Recommendations

Gila is optmized for single-node workloads, multi-node jobs may experience degraded performance. All MPI distribution flavors work on Gila, with noted performance from Intel-MPI. Gila is single-threaded, and applications that are compiled to make use of multiple threads will not be able to take advantage of this. 


## Example: Compiling a Program on Gila

In this section we will describe how to compile an MPI based application using an Intel toolchain from the module system. For a more in-depth explanation on the module system itself and how to use it, check out our "Modules" section.


### Requesting an interactive session
First, we will begin by requesting an interactive session. This will give us a compute node from where we can carry out our work. An example command for requesting such a session is as follows

```salloc -N 1 -n 60 --mem 60GB --partition=amd --account=aurorahpc --time=01:00:00```

This will request a single node from the AMD partition with 60 cores and 60 GB of memory for one hour. We request this node using the ```aurorahpc``` account that is open to all NLR researchers, but if you have an HPC allocation, please replace ```aurorahpc``` with the name of your HPC allocation.

### Loading necessary modules

Once we have an allocated node, we will need to load the initial Intel module for the toolchain `oneapi`. This will give us access to the Intel toolchain, and we will we now load the module ```intel-oneapi-mpi``` to give us access to Intel MPI. Please note, you can always check what modules are available to you at any point by using the command ```module avail``` and you can also check what modules you have loaded by using the command ```module list```. The commands for loading the modules that we need are as follows

```bash
module load oneapi
module load intel-oneapi-mpi
```

### Copying program files

We now have access to the tools we need from the Intel toolchain in order to be able to compile a program! First, switch directories to a directory under /projects or /scratch, and create a directory called 'program-compilation' by running the following command, and we will then switch into the newly created directory.

```bash
mkdir program-compilation
cd program-compilation 
```

Now that we are in the newly created directory, we are going to copy a set of files from another directory **/nopt/nrel/apps/210929a**. The file that we are copying from that directory is the **phostone.c** file, and we are going to copy it directly into the **program-compilation** directory that we are currently in. The command to do so is as follows

```rsync -avP /nopt/nrel/apps/210929a/example/phostone.c .```

Rsync is a copy command that is commonly used for transferring files, and the parameters that we put into the command allow for us to see the progress of the file transfer and preserving important file characteristics. 

### Program compilation

Once the file is copied, we can now compile the program. The command we need to use in order to compile the program is as follows

```bash
mpiicx -qopenmp phostone.c -o phost.intelmpi
```

The command we used ```mpiicx``` is the Intel MPI compiler that was loaded from the module ```intel-oneapi-mpi```, and we specified the flag of ```-qopenmp``` right afterwards to make sure that the OpenMP compiled portions of the program are abled to be loaded. We then specified the file name as **phost.intelmpi** using the ```-o``` flag. 

### Submitting a job

The following batch script is an example that will submit the job to the jobscheduler, requesting two cores to use two MPI ranks on a single node, with a run time of up to an hour. Save this script to a file such as submit_intel.sh, and submit using sbatch submit_intel.sh. Again, if you have an HPC allocation, we request that you replace ```aurorahpc``` with the name of your HPC allocation.

??? example "Batch Submission Script - Intel MPI"

    ```bash
    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --ntasks=2
    #SBATCH --cpus-per-task=2
    #SBATCH --exclusive
    #SBATCH --time=00:01:00
    #SBATCH --mem=20GB
    #SBATCH --account=aurorahpc

    module load oneapi
    module load intel-oneapi-mpi

    srun --cpus-per-task 2 -n 2 ./phost.intelmpi -F
    ```

Your output should look similar to the following

```
MPI VERSION Intel(R) MPI Library 2021.14 for Linux* OS

task    thread             node name  first task    # on node  core
0000      0000    gila-compute-36.novalocal        0000         0000  0001
0000      0001    gila-compute-36.novalocal        0000         0000  0000
0001      0000    gila-compute-36.novalocal        0000         0001  0031
0001      0001    gila-compute-36.novalocal        0000         0001  0030
```


### Compiling with OpenMPI

We can now follow these steps using OpenMPI as well! First, we will use some commands to unload the Intel modules that we loaded from the Intel toolchain. We will then load GNU modules and OpenMPI using the module load command from earlier. The commands we are going to execute are as follows

```bash
module unload intel-oneapi-mpi
module unload oneapi
module load gcc
module load openmpi
```

We can then compile the phost program again by using the following commands.

```bash
mpicc -fopenmp phostone.c -o phost.openmpi
```

Once the program has been compiled against OpenMPI, we can go ahead and submit another batch script to test the program!


??? example "Batch Submission Script - OpenMPI"

    ```bash
    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --ntasks=2
    #SBATCH --cpus-per-task=2
    #SBATCH --exclusive
    #SBATCH --time=00:01:00
    #SBATCH --mem=20GB
    #SBATCH --account=aurorahpc

    module load gcc
    module load openmpi

    srun --cpus-per-task 2 -n 2 ./phost.openmpi -F
    ```
