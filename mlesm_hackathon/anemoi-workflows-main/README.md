# anemoi-workflows

Welcome to the anemoi challenge.

## Tasks

Model Design: Start from basic ML layers, activations, and
gradually design the full forecasting architectures.​

Explore changes in:​

- Model architecture​: 
    - modify `anemoi_configs/model/` to try different architectures and modify number of layers etc.
    - https://anemoi.readthedocs.io/projects/training/en/latest/user-guide/models.html

- Training schedules​
    - modify `anemoi_configs/training/`
    - try different rollout strategies initialising from no_rollout.ckpt
    - https://anemoi.readthedocs.io/projects/training/en/latest/user-guide/training.html#learning-rate


- Variable inputs​
    - modify `anemoi_configs/data/`
    - make some variables forcings and others diagnostics. Does this improve forecasts or degrade?

- Loss scaling & loss functions​
    - modify `anemoi_configs/training/scalings/`
    - scale losses with different scalings
      https://anemoi.readthedocs.io/projects/training/en/latest/user-guide/training.html#loss-function-scaling
      https://anemoi.readthedocs.io/projects/training/en/latest/user-guide/training.html#loss-functions 


## Running Anemoi

We will be using the `anemoi` framework for this challenge, all the tasks should be possible
with modifications to the config files.

### getting an interactive node
`srun --nodes=1 --gres=gpu:4 --account=training2533 --time=00:10:00 --partition=dc-gpu-devel --pty bash -i`

### training anemoi
`anemoi-training train --config-name=*****.yaml`

## Using Earthkit
As `earthkit` will likely be a new tool, we've put together a small crash course, going over the basics. Checkout the docs or talk to your tutors for more information.

[EarthkitCrashCourse](EarthkitCrashCourse.ipynb)

## MLFlow server

To visualise the metrics and artifacts of your training do the following,

- In one process run,

```mlflow server```

- In another you will sync the run with,

```anemoi-training mlflow sync -s REALPATH_TO_THE_output/logs/mlflow -d http://127.0.0.1:5000 -r RUN_ID```

The runID can be found as the second set of random digits under the `output/logs/mlflow`, i.e.
`/p/project1/training2533/cook2/output/logs/mlflow/135543206004832408/1101027e8db34b888f51c5bad02d0511`
The run id is `1101027e8db34b888f51c5bad02d0511`.

Than go back to the mlflow server with port forwarding and see your metrics.

## References

[earthkit](https://earthkit.readthedocs.io/en/latest/)
