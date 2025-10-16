
# About Gila

Gila is an OpenHPC-based cluster running on __Dual AMD EPYC 7532 Rome CPUs__ and __Intel Xeon Icelake CPUs with NVidia A100 GPUs__. The nodes run as virtual machines in a local virtual private cloud (OpenStack). Gila is allocated for NREL workloads and intended for LDRD, SPP or Office of Science workloads. Allocation decisions are made by the IACAC through the annual allocation request process. Check back regularly as the configuration and capabilities for Gila are augmented over time.

## Accessing Gila
Access to Gila requires an NREL HPC account and permission to join an existing allocation. Please see the [System Access](https://www.nrel.gov/hpc/system-access.html) page for more information on accounts and allocations.

#### For NREL Employees:
To access Gila, log into the NREL network and connect via ssh:

    ssh gila.hpc.nrel.gov

#### For External Collaborators:
There are currently no external-facing login nodes for Gila. There are two options to connect:

1. Connect to the [SSH gateway host](https://www.nrel.gov/hpc/ssh-gateway-connection.html) and log in with your username, password, and OTP code. Once connected, ssh to the login nodes as above.
1. Connect to the [HPC VPN](https://www.nrel.gov/hpc/vpn-connection.html) and ssh to the login nodes as above.

There are currently two login nodes. They share the same home directory so work done on one will appear on the other. They are:

    gila-login-1
    gila-login-2

You may connect directly to a login node, but they may be cycled in and out of the pool. If a node is unavailable, try connecting to another login node or the `gila.hpc.nrel.gov` round-robin option.

## Get Help with Gila

Please see the [Help and Support Page](../../help.md) for further information on how to seek assistance with Gila or your NREL HPC account. 

## Building code

Do not build or run code on login nodes. Login nodes have limited CPU and memory available. Use a compute or GPU node instead. Simply start an interactive job on an appropriately provisioned node and partition for your work and do your builds there. Similarly, build your projects under `/projects/your_project_name/` as home directories are **limited to 5GB** per user.


---
