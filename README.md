# Pangeo Docker Images

![Build Status](https://github.com/pangeo-data/pangeo-stacks-dev/workflows/Build/badge.svg)
![Publish Status](https://github.com/pangeo-data/pangeo-stacks-dev/workflows/Publish/badge.svg)
![DockerHub Version](https://img.shields.io/docker/v/pangeo/base-image?sort=date)

Latest DockerHub Images: https://hub.docker.com/orgs/pangeo/repositories 
| Image           | Description                                   |  Size | Pulls |
|-----------------|-----------------------------------------------|--------------|-------------|
| base-image      | Foundational Dockerfile for builds            | ![](https://img.shields.io/docker/image-size/pangeo/base-image?sort=date) | ![](https://img.shields.io/docker/pulls/pangeo/base-image?sort=date)
| base-notebook   | minimally functional image for pangeo hubs    | ![](https://img.shields.io/docker/image-size/pangeo/base-notebook?sort=date) | ![](https://img.shields.io/docker/pulls/pangeo/base-notebook?sort=date)
| pangeo-notebook | above + core earth science analysis packages  | ![](https://img.shields.io/docker/image-size/pangeo/pangeo-notebook?sort=date) | ![](https://img.shields.io/docker/pulls/pangeo/pangeo-notebook?sort=date)
| ml-notebook     | above + GPU-enabled tensorflow2               | ![](https://img.shields.io/docker/image-size/pangeo/ml-notebook?sort=date) | ![](https://img.shields.io/docker/pulls/pangeo/ml-notebook?sort=date)

### Design:

  1. compatible with [Pangeo BinderHubs](https://github.com/pangeo-data/pangeo-binder) and [JupyterHubs](https://github.com/pangeo-data/pangeo-cloud-federation)
  1. compatible with [Repo2Docker Python configuration files](https://repo2docker.readthedocs.io/en/latest/config_files.html)
  1. reproducible build process and explicit conda package lists
  1. small size, fast build
  1. easy to customize

Everything stems from the `Dockerfile` in the `base-image` folder. The `base-image` configures default settings for Conda and Dask with `condarc.yml` and `dask_config.yml` files. The `base-image` is not meant to run on its own, it is the common foundation for `-notebook` images that install Python packages including JupyerLab and lab extensions. Lists of Conda packages for each image are specified in an `environment.yml` in each `-notebook` folder, and compatible Dask and Jupyter packages are guaranteed by specifying the `pangeo-notebook` [conda metapackage](https://github.com/conda-forge/pangeo-notebook-feedstock).

You can pre-solve for compatible environments locally with [conda-lock](https://github.com/mariusvniekerk/conda-lock/blob/master/README.md) to convert a human-editable `environment.yml` file to [spec-file.txt](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#building-identical-conda-environments) which is an explicit list of compatible packages solved by Conda. The major advantage of doing this is that if you rebuild at a later date the resulting image is identical, which is important for reproducibility. For this reason, building off the `base-image` a `spec-file.txt` is preferred over `environment.yml`.

### Image tagging and "continuous building"
All images are public on DockerHub: https://hub.docker.com/orgs/pangeo

* Pull requests from forks trigger rebuilding all image but can't push to DockerHub because they don't have access to repo secrets for authentication.

* `pangeo/base-notebook:master` corresponds to current "staging" image in sync with master branch. Built with every commit to master. Also tagged with short GitHub short SHA `pangeo/base-notebook:2639bd3`.

* Tags pushed to GitHub represent "production" releases with corresponding tags on dockerhub `pangeo/pangeo-notebook:2020.03.11`. The `latest` tag also corresponds to the most recent GitHub tag.

### To build locally (and make a PR)
**Important!!!** regenerating the conda-lockfile is not currently done through CI. You need to create this file locally and include it in your PR. You'll need at least Conda installed, and Docker if you want to build and test locally.
```
# create a fork of this repo and clone it locally
git clone https://github.com/mygithub/pangeo-stacks-dev
cd pangeo-stacks-dev
# Install conda-lock
conda env create -f environment-condalock.yml
git checkout -b change-pangeo-notebook
```

edit `pangeo-notebook/environment.yml` to change packages! Note that `make pangeo-notebook` is a convenient shortcut to build and test. See the Makefile for specific commands that are run. For example, you can just run conda-lock and don't have to build and test locally.
```
make pangeo-notebook
git commit -a -m "added x packages, changed x version"
git push
# go to github to create PR, or use github cli https://cli.github.com
```

### Use base-image for BinderHub-compatible repos
https://github.com/scottyhq/pangeodev-binder

### To run locally
```
docker run -it --rm -p 8888:8888 pangeo/base-notebook:latest jupyter lab --ip 0.0.0.0
```
