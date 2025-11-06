---
title: LBM-cfd
parent: Applications
---

# Lattice Boltzmann Method based CFD Applications: M-Star, marbles, Ansys Discovery
<!---
**Documentation:** [ link to documentation](https://nrel.gov)
-->


The lattice Boltzmann method (LBM) is a novel and unique simulation method whose meshless and exact conservation combines the best parts of the immersed boundary method and the finite volume method, without the hassle of mesh generation. The method completely does away with spatial discretisation in favour of advection of particles with pre-determined discrete velocities such that they hop to lattice sites on a structured grid. Consequently, the method does not incur any errors due to numerical dissipation or dispersion, thereby ensuring conservation of globally conserved properties like mass and total energy. The time discretisation is done with the trapezoidal rule, which results into transient simualations with second order accuracy in time. The LBM has been successfully applied to a range of problems in fluid dynamics including but not limited to transitional flows, flows involving complex moving geometries, compressible flows, multiphase flows, rarefied gases, combustion, electrochemical devices etc.. 

Its meshfree nature makes it very convenient to handle and resolve complex geomtries such as cracks and porous microstructures. The algorithmically simple nature of the LBM which consists of hopping of particles by a pre-determined distance followed by a local update for time increment makes the solver trivial to implement on a GPU, which results into very fast and scalable solvers that can be used as a data generators in a machine learning pipeline. 


![alt text](LBMcfd_metadata/lbmAlgo.png)

The LBM is a recast of fluid dynamics into a fully discrete kinetic system for the populations $f_i(\mathbf{x},t)$ of particles, which are associated with the discrete velocities $\mathbf{c}_i$ fitting into a regular space-filling lattice. As a result, the kinetic equations for the populations $f_i(\mathbf{x},t)$ follow a simple algorithm of `"stream along links $\mathbf{c}_i$ and collide at the nodes $\mathbf{x}$ in discrete time $t$". The method computes a discrete version of the Boltzmann transport equation, which mathematically describes the state of the fluid with a Gaussian distribution in the velocity space with its mean representing the local fluid velocity and the variance representing the local energy of the fluid. The dynamics of the fluid then evolve with a streaming-relaxation equation for these probability distribution functions. The probablistic nature of the method makes it a gateway to quantum computing for CFD. 



## Overview

At NREL, serveral packages are available for the purpose, each with their strengths, pros and cons. The matrix below provides a birds eye view of the available packages. (All company, product and service names used on this page are for identification purposes only. Use of these names, trademarks and brands does not imply endorsement.)

|                                                                              | Windows| Mac OS  | Linux (HPC) | CPU    | GPU    | Cost | Speciality                   |
|:----------------------------------------------------------------------------:|:------:|:-------:|:-----------:|:------:|:------:|:----:|:----------------------------:|
| [M-Star](https://mstarcfd.com/)                                              | y      | x       | y           | y      | y      | $    | GUI, moving geometries       |
| [NREL marbles](https://nrel.github.io/marbles/VandV.html)                         | y      | y       | y           | y      | y      | Free | Open source, compressible  |  
| [Ansys Discovery](https://www.ansys.com/products/3d-design/ansys-discovery)  | y      | x       | x           | x      | y      | $    | GUI, geometry modeling       |

Only M-Star and marbles can be run on the Kestrel HPC system. Users with an access to GPU enabled Windows computers or Virtual Machines may try Ansys Discovery at their own discretion.

## Installation and usage on Kestrel

### NREL marbles

Source code of marbles is available on github. It can be compiled and run on nvidia and AMD GPUs as well as Intel, AMD and Apple M series CPUs. Here, we show the process to compile and run it on the Kestrel HPC system with nvidia GPUs.

Create a new directory in the `projects` partition
```
$ cd /projects/<projectname>/<username>/
$ mkdir marblesLBM
```

Get the `amrex` dependency and set the environment variable `AMREX_HOME`
```
$ cd /projects/<projectname>/<username>/marblesLBM
$ git clone https://github.com/AMReX-Codes/amrex.git
$ cd amrex
$ git checkout 25.11
$ cd ..
$ echo "export AMREX_HOME=/projects/<projectname>/<username>/marblesLBM/amrex" >> ~/.bash_profile
$ bash
```

Get the stable and development version of marbles
```
$ cd /projects/<projectname>/<username>/marblesLBM
$ git clone https://github.com/NREL/marbles.git
$ git clone https://github.com/nileshsawant/marblesThermal
```

To install the latest development version of marbles, the code has to be built on a GPU login node. Please do the following:
```
$ ssh -X <username>@kestrel-gpu.hpc.nrel.gov
$ module load PrgEnv-gnu/8.5.0
$ module load cuda/12.3
$ module load craype-x86-milan
$ cd /projects/<projectname>/<username>/marblesLBM/marblesThermal
$ cd Build
$ make
$ make USE_CUDA=TRUE
$ ls -tr
GNUmakefile  cmake.sh  tmp_build_dir  marbles3d.gnu.x86-milan.TPROF.MPI.ex  marbles3d.gnu.TPROF.MPI.CUDA.ex
```
If the commands succeed, the `Build` directory should contain the MPI version `marbles3d.gnu.x86-milan.TPROF.MPI.ex` and the MPI + CUDA version `marbles3d.gnu.TPROF.MPI.CUDA.ex` of marbles. 

The test case for flow through fractures with heated isothermal walls can be tried out as follows:
```
$ salloc -A hpcapps -t 00:30:00 --nodes=1 --ntasks-per-node=32 --mem=80G --gres=gpu:1 --partition=debug
$ module load cuda/12.3
$ cd /projects/<projectname>/<username>/marblesLBM/marblesThermal/Build
$ cp ../Tests/test_files/isothermal_cracks/* .
# Test CPU version 
$ srun -n 4 marbles3d.gnu.x86-milan.TPROF.MPI.ex isothermal_cracks.inp
# Test GPU version
$ srun -n 1 marbles3d.gnu.TPROF.MPI.CUDA.ex isothermal_cracks.inp
```

Results can be viewed in [ParaView](https://nrel.github.io/HPC/Documentation/Viz_Analytics/paraview/) or [VisIT](https://nrel.github.io/HPC/Documentation/Viz_Analytics/visit/).

![Velocity Cracks Demo](LBMcfd_metadata/velocity_cracks.gif)
*Animation credit: [@eyoung55](https://github.com/eyoung55)*

[marbles](https://nrel.github.io/marbles/VandV.html) is an in-house effort to make a free lattice Boltzmann solver available to the community. We encourage users to contact us for help setting up your problem or to request additional features. Please visit the repository and create a [`New issue`](https://github.com/NREL/marbles/issues) or [email](mailto:nsawant@nrel.gov) us directly. A [machine learning framework](https://github.com/nileshsawant/mlForLBM) for using marbles in the loop as data generator has also been created. Pre-built executibles, `marbles3d.gnu.x86-milan.TPROF.MPI.ex` and `marbles3d.gnu.TPROF.MPI.CUDA.ex`, can also be made available on request.

### M-Star

!!! Warning
	Users are advised to not leave this application open when not working on it. The license of this product allows only one user at a time.

The M-Star GUI can be accessed though a [FastX virtual desktop](../Viz_Analytics/virtualgl_fastx.md). M-Star is a resourse intensive application whose backed uses cuda aware openmpi to utlise multiple GPUs for computation. The application is always executed on a dedicated compute node while its GUI is interacted with on a FastX node. The steps to use M-Star are as follows:

1. Open a terminal in a FastX session and ask for an [allocation](../Slurm/interactive_jobs.md). For example,
```
$ salloc -A <projectname> -t 01:00:00 --nodes=1 --ntasks-per-node=64 --mem=160G --gres=gpu:2 --partition=debug
```
2. Wait until you obtain an allocation, The terminal will display `<username>@<nodename>` when successful.
3. Open a new terminal tab by right clicking on empty in the terminal. In the new terminal tab, execute the following to connect to the node you have been allocated.
```
$ ssh -X <nodename>
```
4. You are now on a compute node with [X forwarding](https://en.wikipedia.org/wiki/X_Window_System) to a FastX desktop session, ready to run GUI applications. To run M-Star, execute the following in this new terminal tab:
```
$ module load mstar
$ mstar
```

The above process will let you use utilize 64 cores, 160 GB of RAM and 2 GPUs for 1 hour, as requested in the `salloc` command above.
Users can try examples [tutorials](https://docs.mstarcfd.com/1a_Tutorials/index.html) from the offical documentation. The [Simple Agitated Tank example](https://docs.mstarcfd.com/1a_Tutorials/simple-agitated-tank.html) which is relevant to bioreactors has been tested successfully on Kestrel. 


