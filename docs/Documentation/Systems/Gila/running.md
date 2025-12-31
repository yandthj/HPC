# Running on Gila

*Learn about compute nodes and job partitions on Gila.*


## Compute hosts

Compute nodes in Gila are virtualized nodes running on either __Dual AMD EPYC Milan CPUs__ or __Intel Xeon Icelake CPUs__. These nodes are not configured as exclusive and can be shared by multiple users or jobs. 

## GPU hosts

GPU nodes available in Gila have NVidia A100 GPU's running on __Intel Xeon Icelake CPUs__.

## Shared file systems

Gila's home directories are shared across all nodes. Each user has a quota of 5 GB. There are also `/scratch/$USER` and `/projects` spaces seen across all nodes.

## Partitions

A list of partitions can be found by running the `sinfo` command.  Here are the partitions as of 12/30/2025

| Partition Name                          | CPU | Qty | RAM    | Cores/node |  AU Charge Factor | 
| :--:                                    | :--:| :--:| :--:   | :--:       |  :--:             |                         
| gpu<br>*NVIDIA Tesla A100-40*<br>       |  Intel Xeon Icelake |  1  | 910 GB |   42            |   12 |      
| amd                                | 2x 30 Core AMD Epyc Milan |  36  | 220 GB |   60            |    7 |
| gh                                |  |  5  | 470 GB |       72       |    7 |

## Allocation Unit (AU) Charges

The equation for calculating the AU cost of a job on Gila is: 

```AU cost = (Walltime in hours * Number of Nodes * Charge Factor)```

The Walltime is the actual length of time that the job runs, in hours or fractions thereof.

The **Charge Factor** for each partition is listed in the table above. 

<!--  *Add example AU calculation, like Swift page* -->

## Operating Software

The Gila HPC cluster runs on Rocky Linux 9.5.

<!-- Docs from Vermilion page: -->
<!-- ## Examples: Build and run simple applications

This section discusses how to compile and run a simple MPI application, as well as how to link against the Intel MKL library.

In the directory **/nopt/nrel/apps/210929a** you will see a subdirectory **example**.  This contains a makefile for a simple hello world program written in both Fortran and C and several run scripts. The README.md file contains additional information, some of which is replicated here. 

We will begin by creating a new directory and copying the source for a simple MPI test program.  More details about the test program are available in the README.md file that accompanies it.  Run the following commands to create a new directory and make a copy of the source code:

```bash
mkdir example
cd example
cp /nopt/nrel/apps/210929a/example/phostone.c .
```

### Compile and run with Intel MPI

First we will look at how to compile and run the application using Intel MPI.  To build the application, we load the necessary Intel modules.  Execute the following commands to load the modules and build the application, naming the output `phost.intelmpi`.  Note that this application uses OpenMP as well as MPI, so we provide the `-fopenmp` flag to link against the OpenMP libraries.

```bash
ml intel-oneapi-mpi intel-oneapi-compilers
mpiicc -fopenmp phostone.c -o phost.intelmpi
```

The following batch script is an example that runs the job using two MPI ranks on a single node with two threads per rank.  Save this script to a file such as `submit_intel.sh`, replace `<myaccount>` with the appropriate account, and submit using `sbatch submit_intel.sh`.  Feel free to experiment with different numbers of tasks and threads.  Note that multi-node jobs on Vermilion can be finicky, and applications may not scale as well as they do on other systems.  At this time, it is not expected that multi-node jobs will always run successfully.


??? example "Intel MPI submission script"

    ```bash
    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --exclusive
    #SBATCH --time=00:01:00
    #SBATCH --account=<myaccount>

    ml intel-oneapi-mpi intel-oneapi-compilers

    export OMP_NUM_THREADS=2
    export I_MPI_OFI_PROVIDER=tcp
    srun --mpi=pmi2 --cpus-per-task 2 -n 2 ./phost.intelmpi -F
    ```
    
Your output should look similar to the following:

```
MPI VERSION Intel(R) MPI Library 2021.9 for Linux* OS

task    thread             node name  first task    # on node  core
0000      0000           vs-std-0044        0000         0000  0001
0000      0001           vs-std-0044        0000         0000  0000
0001      0000           vs-std-0044        0000         0001  0003
0001      0001           vs-std-0044        0000         0001  0002
```

### Link Intel's MKL library

The `intel-oneapi-mkl` module is available for linking against Intel's MKL
library.  Then to build against MKL using the Intel compilers icc or ifort, you
normally just need to add the flag `-qmkl`. There are examples in the directory
`/nopt/nrel/apps/210929a/example/mkl`, and there is a Readme.md file that
explains in a bit more detail.

To compile a simple test program that links against MKL, run:

```bash
cp /nopt/nrel/apps/210929a/example/mkl/mkl.c .

ml intel-oneapi-mkl intel-oneapi-compilers
icc -O3 -qmkl mkl.c -o mkl
```

An example submission script is:

??? example "Intel MKL submission script"

    ```bash
    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --exclusive
    #SBATCH --time=00:01:00
    #SBATCH --account=<myaccount>

    source /nopt/nrel/apps/210929a/myenv.2110041605
    ml intel-oneapi-mkl intel-oneapi-compilers gcc

    ./mkl
    ```


### Compile and run with Open MPI

!!! warning

    Please note that multi-node jobs are not currently supported with Open MPI.

Use the following commands to load the Open MPI modules and compile the test program into an executable named `phost.openmpi`:

```bash
ml gcc openmpi
mpicc -fopenmp phostone.c -o phost.openmpi
```

The following is an example script that runs two tasks on a single node, with two threads per task:

??? example "Open MPI submission script"

    ```bash
    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --exclusive
    #SBATCH --time=00:01:00
    #SBATCH --account=<myaccount>

    ml gcc openmpi

    export OMP_NUM_THREADS=2
    mpirun -np 2 --map-by socket:PE=2 ./phost.openmpi -F
    ```


## Running VASP on Vermilion

Please see the [VASP page](../../Applications/vasp.md) for detailed information and recommendations for running VASP on Vermilion. -->
