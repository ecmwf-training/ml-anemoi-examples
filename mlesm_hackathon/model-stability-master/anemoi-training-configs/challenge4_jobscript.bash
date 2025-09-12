#!/bin/bash
#SBATCH --partition=dc-gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --gres=gpu:4 
#SBATCH --cpus-per-task=16
#SBATCH --mem=180G
#SBATCH --time=00:10:00
#SBATCH --account=training2533
#SBATCH --output=challenge4_out-atmo.%j

# Name and notes optional

# generic settings

CONFIGDIR=/p/project1/training2533/$USER/model-stability/anemoi-training-configs/
WORKDIR=$CONFIGDIR

cd $WORKDIR

export NCCL_IB_TIMEOUT=50 
export UCX_RC_TIMEOUT=4s
export NCCL_IB_RETRY_CNT=10
# export NCCL_DEBUG=TRACE
# export TORCH_CPP_LOG_LEVEL=INFO
# export TORCH_DISTRIBUTED_DEBUG=DETAIL
# export HYDRA_FULL_ERROR=1

start=`date +%s.%N`

module use /p/project1/training2533/apps/modules
module load anemoi

srun anemoi-training train --config-name=atmosphere_hackathon25_rollout

end=`date +%s.%N`
runtime=$( echo "($end - $start)/60" | bc -l )
runtime=$(printf "%.2f" $runtime)
echo "Runtime $runtime minutes"
