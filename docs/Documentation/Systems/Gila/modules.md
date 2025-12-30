# Modules on Gila

On Gila, modules are deployed and organized slightly differently than on other NLR HPC systems. 
While the basic concepts of using modules remain the same, there are important differences in how modules are structured, discovered, and loaded. These differences are intentional and are designed to improve compatibility, reproducibility, and long-term maintainability. The upcoming sections of this document will walk through these differences step by step.

The module system used on this cluster is [Lmod](../../Environment/lmod.md).

When you log in to Gila, three modules are loaded automatically by default:

1. `Core/25.05`
2. `DefApps`
3. `gcc/14.2.0`

!!! note
    The `DefApps` module is a convenience module that ensures both `Core` and `GCC` are loaded upon login or when you use `module restore`. It does not load additional software itself but guarantees that the essential environment is active.


## Module Structure on Gila

Modules on Gila are organized into two main categories: **Base Modules** and **Core Modules**. This structure is different from many traditional flat module trees and is designed to make software compatibility explicit and predictable.

### Base Modules

**Base modules** define the *software toolchain context* you are working in. Loading a base module changes which additional modules are visible and available.

Base modules allow users to:

* **Initiate a compiler toolchain**
    * Loading a specific compiler (for example, `gcc` or `oneapi`) establishes a toolchain
    * Once a compiler is loaded, only software built with and compatible with that compiler becomes visible when running `ml avail`
    * This behavior applies to both **GCC** and **Intel oneAPI** toolchains

* **Use Conda/Mamba environments**
    * Loading `miniforge3` enables access to Conda and Mamba for managing user-level Python environments

* **Access installed research applications**
    * Loading the `application` module exposes centrally installed research applications

* **Enable CUDA and GPU-enabled software**
    * Loading the `cuda` module provides access to CUDA
    * It also makes CUDA-enabled software visible in `module avail`, ensuring GPU-compatible applications are only shown when CUDA is loaded

In short, **base modules control which families of software are visible** by establishing the appropriate environment and compatibility constraints.

### Core Modules

**Core modules** are independent of any specific compiler or toolchain.

They:

* Do **not** rely on a particular compiler
* Contain essential utilities, libraries, and tools
* Are intended to work with **any toolchain**

Core modules are typically always available and can be safely loaded regardless of which compiler, CUDA version, or toolchain is active.

This separation between Base and Core modules ensures:

* Clear compiler compatibility
* Reduced risk of mixing incompatible software
* A cleaner and more predictable module environment


## MPI-Enabled Software

MPI-enabled software modules are identified by a `-mpi` suffix at the end of the module name.

Similar to compiler modules, MPI-enabled software is **not visible by default**. These modules only appear after an MPI implementation is loaded. Supported MPI implementations include `openmpi`, `mpich`, and `intelmpi`.

Loading an MPI implementation makes MPI-enabled software that was installed with that specific MPI stack available when running `module avail`.

This behavior ensures that only software built against the selected MPI implementation is exposed, helping users avoid mixing incompatible MPI libraries.

!!! note
    To determine whether a software package is available on the cluster, use `module spider`. This command lists **all available versions and configurations** of a given software, including those that are not currently visible with `module avail`.
    
    To find out which modules must be loaded in order to access a specific software configuration, run `module spider` using the **full module name**. This will show the required modules that need to be loaded to make that software available.


## Containers

Container tools such as **Apptainer** and **Podman** do not require module files on this cluster. They are available on the system **by default** and are already included in your `PATH`.

This means you can use Apptainer and Podman at any time without loading a specific module, regardless of which compiler, MPI, or CUDA toolchain is currently active.


## Module Commands: restore, avail, and spider

### module restore

The `module restore` command reloads the set of modules that were active at the start of your login session or at the last checkpoint. This is useful if you have unloaded or swapped modules and want to return to your original environment.

Example:

```bash
module restore
```

This will restore the default modules that were loaded at login, such as `Core/25.05`, `DefApps`, and `gcc/14.2.0`.

### module avail

The `module avail` command lists all modules that are **currently visible** in your environment. This includes modules that are compatible with the loaded compiler, MPI, or CUDA base modules.

Example:

```bash
module avail
```

You can also search for a specific software:

```bash
module avail python
```

### module spider

The `module spider` command provides a **complete listing of all versions and configurations** of a software package, including those that are **not currently visible** with `module avail`. It also shows **which modules need to be loaded** to make a specific software configuration available.

Example:

```bash
module spider python/3.10
```

This output will indicate any prerequisite modules you need to load before the software becomes available.

!!! tip
    Use `module avail` for quick checks and `module spider` when you need full details or to resolve dependencies for specific versions.


## Frequently Asked Questions

??? note "I can't find the module I need."
    Please email [HPC-Help](mailto:HPC-Help@nrel.gov). The Apps team will get in touch with you to provide the module you need.

??? note "I need to mix and match compilers and libraries/MPI. How can I do that?"
    Modules on Gila do not support mixing and matching. For example, if `oneapi` is loaded, only software compiled with `oneapi` will appear. If you require a custom combination of software stacks, you are encouraged to use **Spack** to deploy your stack. Please contact [HPC-Help](mailto:HPC-Help@nrel.gov) to be matched with a Spack expert.

??? note "Can I use Miniforge with other modules?"
    While it is technically possible, Miniforge is intended to provide an isolated environment separate from external modules. Be careful with the order in which modules are loaded, as this can impact your `PATH` and `LD_LIBRARY_PATH`.

??? note "What if I want a different CUDA version?"
    Other CUDA versions are available under **CORE** modules. If you need additional versions, please reach out to [HPC-Help](mailto:HPC-Help@nrel.gov). Note that CUDA modules under CORE do **not** automatically make CUDA-enabled software available; only CUDA modules under **Base** modules will load CUDA-enabled packages.
