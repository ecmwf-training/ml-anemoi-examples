#!/bin/bash

#SBATCH --account=ecaifs
#SBATCH --qos=ng
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --gpus-per-node=4
#SBATCH --cpus-per-task=8
#SBATCH --mem=256G
#SBATCH --time=12:00:00
#SBATCH --output=ens-score-dl-profile-h4-atos.out.%j
#SBATCH --exclude=ac6-318
#SBATCH --exclude=ac6-320

# debugging flags (optional)
#export NCCL_DEBUG=INFO
# export PYTHONFAULTHANDLER=1
export HYDRA_FULL_ERROR=1
export OC_CAUSE=1
# export NCCL_DEBUG=TRACE
# export TORCH_CPP_LOG_LEVEL=INFO
# export TORCH_DISTRIBUTED_DEBUG=DETAIL
# export CUDA_LAUNCH_BLOCKING=1

# on your cluster you might need these:
# set the network interface
# export NCCL_SOCKET_IFNAME=ib0,lo

# generic settings
#VENV=aifs_anemoi
GITDIR=/perm/momc/anemoi_configs
WORKDIR=$GITDIR

cd $WORKDIR

source /perm/ecm9784/envs/hackathon25/bin/activate


srun anemoi-training train hardware=atos_slurm training.run_id=5440dece28cd4ae98338a283815a05a1 diagnostics.log.mlflow.run_name="bench o96 roll" --config-name=debug_rollout

