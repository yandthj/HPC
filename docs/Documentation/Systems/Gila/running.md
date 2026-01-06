# Running on Gila

*Learn about compute nodes and job partitions on Gila.*


## Compute Nodes

Compute nodes in Gila are virtualized nodes. **These nodes are not configured as exclusive and can be shared by multiple users or jobs.** Be sure to request the resources that your job needs, including memory and cores.


## GPU hosts

GPU nodes in Gila have NVIDIA A100 GPUs running on __Intel Xeon Icelake CPUs__.


There are also 5 NVIDIA Grace Hopper nodes. To use the Grace Hopper nodes, submit your jobs to the gh partition from the `gila-hopper-login1.hpc.nrel.gov` login node. 


## Partitions

A list of partitions can be found by running the `sinfo` command.  Here are the partitions as of 12/30/2025

| Partition Name                          | CPU |  GPU | Qty | RAM    | Cores/node |
| :--:                                    | :--:| :--: | :--:| :--:   | :--:       |                        
| gpu       |  Intel Xeon Icelake | NVIDIA Tesla A100-80 |  1  | 910 GB |   42            |      
| amd                                | 2x 30 Core AMD Epyc Milan |  |  36  | 220 GB |   60            |
| gh                                | NVIDIA Grace | GH200 |  5  | 470 GB |       72       |


## Performance Recommendations

Gila is optmized for single-node workloads. Multi-node jobs may experience degraded performance. 




