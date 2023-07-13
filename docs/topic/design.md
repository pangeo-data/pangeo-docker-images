# Design Goals

1. compatible with [Pangeo BinderHubs](https://github.com/pangeo-data/pangeo-binder) and [JupyterHubs](https://github.com/pangeo-data/pangeo-cloud-federation)
1. compatible with [Repo2Docker Python configuration files](https://repo2docker.readthedocs.io/en/latest/config_files.html)
1. reproducible build process and explicit conda package lists
1. small size, fast build
1. easy to customize

Everything stems from the `Dockerfile` in the `base-image` folder. The `base-image` configures default settings for Conda and Dask with `condarc.yml` and `dask_config.yml` files. The `base-image` is not meant to run on its own, it is the common foundation for `-notebook` images that install Python packages including JupyerLab and lab extensions. Lists of Conda packages for each image are specified in an `environment.yml` in each `-notebook` folder, and compatible Dask and Jupyter packages are guaranteed by specifying the `pangeo-notebook` [conda metapackage](https://github.com/conda-forge/pangeo-notebook-feedstock).

You can pre-solve for compatible environments locally with [conda-lock](https://github.com/mariusvniekerk/conda-lock/blob/master/README.md) to convert the `environment.yml` file to a [conda-linux-64.lock](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#building-identical-conda-environments) file which is an explicit list of compatible packages solved by Conda. The major advantage of doing this is that if you rebuild at a later date the resulting Conda environment is identical, which improves reproducibility. For this reason, when building off of the `base-image`, any existing `conda-linux-64.lock` file takes precedence over the `environment.yml` file.

