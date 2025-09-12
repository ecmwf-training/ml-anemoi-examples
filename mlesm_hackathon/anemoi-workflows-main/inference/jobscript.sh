#!/bin/bash

#SBATCH --account=training2533
#SBATCH --partition=dc-gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:20:00

module use $PROJECT_training2533/apps/modules
module load anemoi

anemoi-inference run config.yaml
