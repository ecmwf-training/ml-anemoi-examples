# Fine-tuning AIFS towards Observations...

In this hackathon session we will look at fine-tuning the AIFS predictions of total precipitation (`tp`) towards observations from NASA-Integrated Multi-satellitE Retrievals for GPM (IMERG). This will involve changes to configuration files which control the behaviour of training for the AIFS and then launching of different inference experiments to judge the impacts of the fine-tuning.

## NASA IMERG

NASA's Integrated Multi-satellitE Retrievals for GPM (IMERG) product blends data from the GPM satellite constellation to provide global estimates of precipitation. It is based on a extensive calibration against rain-gauges which has been shown to be robust in areas of sparse station observations. More information can be found at <https://gpm.nasa.gov/data/imerg>. The dataset we base our fine-tuning on is similar to that which can already be found under the Anemoi catalogue at <https://anemoi.ecmwf.int/datasets/nasa-imerg-grib-n320-1998-2024-6h-v1>

## Fine-tuning from an existing AIFS checkpoint

In preparation for the hackthon session an AIFS checkpoint has already been trained based on the ERA5 reanalysis dataset regridded to a O96 (~1-degree) spatial resolution. In this challenge we will load this checkpoint to initialise our training but will need to make some changes to replace the ERA5 total precipitation with estimates from IMERG instead. We will also need to change the data ranges and learning rates for the model.

### Changes to `dataloader/native_grid.yaml`

We will need to update the dataloading of the model to use multiple datasets within the training. Updates will need to be made to the `native_grid.yaml` to make sure the IMERG dataset is loaded and referenced correctly within the model:

```
training:
  dataset:
  - dataset: ${hardware.paths.data}/${hardware.files.dataset}
    start: 1999
    end: 2022
    frequency: ${data.frequency}
    drop:  [tp]
  - dataset: ${hardware.paths.dataset_imerg}/${hardware.files.dataset_precip}
    start: 1999
    end: 2022
    frequency: ${data.frequency}
    drop:  []
    rename:
      tp_imerg_0: tp

  start: 1999
  end: 2022
  reorder: {'10u': 0, '10v': 1, '2d': 2, ...,}
  drop: []
```

### Changes to Learning-Rate

Now that the model is able to load the data correctly we will need to consider our fine-tuning strategy (see related lecture on fine-tuning too!). It is important when fine-tuning from an existing model checkpoint to reduce the learning-rate to ensure the model does not "forget" everything it learnt in its initial longer training period. The exact learning-rate that we should set (and the schedule with which it is decayed) is something that we can experiment with. We can try 3 different values and decide on a number of iterations to fine-tune our model for. We can then look at the corresponding training/validation losses to see what impact this has on our model predictions. These changes come under the `training` section of the configs where we can update the following parameters:

```
training:
  max_epochs: 13  # Can run for more/less iterations
  load_weights_only: True
  transfer_learning: True
  lr:
    rate: 8e-7 # Can test increasing/decreasing this value
    iterations: 12000  # More or less iterations to decay the learning-rate to its minimum
    warmup_t: 1000
    min: 3e-7 # Not scaled by GPU
```

## Validating the fine-tuned checkpoints

Once we have a set of fine-tuned checkpoints we can then run inference on these using anemoi-inference <anemoi.readthedocs.io>. In this example we will just launch from the training datasets we used for an independent year, in practice this can be launched in real-time by grabbing data from ECMWF's Mars or Open Data archive at inference time. We can run a number of forecasts for the checkpoints saving them to grib using something similar to the config below:

```
checkpoint: path_to_ckpt.ckpt  # location of fine-tuned ckpt

dates:  # produce forecasts every 12-hours for a given time-range
  start: 2023-07-01 00:00:00
  end: 2023-07-31 00:00:00
  frequency: 12

input: training  # Use the training datasets as input for forecast initialisation

output:
  grib: /output/path/aifs-fine-tune-{shortName}-{level}.grib
```

Once we have our output we can use `earthkit.data` to open up the grib files and begin to do some analysis versus IMERG from the independent year. We show some initial comparisons between IMERG and ERA5 TP below, which can be used as a basis for further expanded forecast validation. What are the best metrics? Validate different forecast lead-times? Look at data distributions? etc.
 