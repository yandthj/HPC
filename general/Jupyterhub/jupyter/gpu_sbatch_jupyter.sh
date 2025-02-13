#!/bin/bash  --login

## Modify walltime and account at minimum
#SBATCH --time=00:01:00		# Change to time required
#SBATCH --account=<allocation_handle>  # Change to allocation handle

#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1		# Change to number of CPUs required per task
#SBATCH --gpus=1           		 # Choose 1, 2, or 4 GPUs as required

export CUDA_VISIBLE_DEVICES=0

# Enable access to new modules for running on GPUs
source /nopt/nrel/apps/gpu_stack/env_cpe23.sh

# Load modules
module purge
ml craype-x86-genoa  # Module to set optimizations for CPUs on GPU nodes
module load conda
source activate /home/$USER/.conda-envs/<MY_ENVIRONMENT>  # insert your conda environment

port=7878

echo "run the following command on your machine"
echo ""
echo "ssh -L $port:$HOSTNAME:$port $SLURM_SUBMIT_HOST.hpc.nrel.gov"

jupyter lab --no-browser --ip=0.0.0.0 --port=$port
