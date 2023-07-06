# Pangeo Docker Images

![Build Status](https://github.com/pangeo-data/pangeo-docker-images/workflows/Build/badge.svg)
![Publish Status](https://github.com/pangeo-data/pangeo-docker-images/workflows/Publish/badge.svg)
![DockerHub Version](https://img.shields.io/docker/v/pangeo/base-image?sort=date)

The images defined in this repository capture reproducible computing environments used by [Pangeo Cloud](https://pangeo.io/cloud.html). They build on top of the Ubuntu operating system and include [conda environments](https://conda.io/projects/conda) with a curated set of Python packages for geospatial analysis. While intended for Pangeo Cloud, they can be used outside of Pangeo infrastructure too!

Images are hosted on [DockerHub](https://hub.docker.com/u/pangeo) and on [Quay.io](https://quay.io/organization/pangeo)

| Image           | Description                                   |  Size | Pulls |
|-----------------|-----------------------------------------------|--------------|-------------|
| base-image      | Foundational Dockerfile for builds            | ![](https://img.shields.io/docker/image-size/pangeo/base-image?sort=date) | ![](https://img.shields.io/docker/pulls/pangeo/base-image?sort=date)
| [base-notebook](base-notebook/packages.txt) | minimally functional image for pangeo hubs | ![](https://img.shields.io/docker/image-size/pangeo/base-notebook?sort=date) | ![](https://img.shields.io/docker/pulls/pangeo/base-notebook?sort=date)
| [pangeo-notebook](pangeo-notebook/packages.txt) | base-notebook + core earth science analysis packages | ![](https://img.shields.io/docker/image-size/pangeo/pangeo-notebook?sort=date) | ![](https://img.shields.io/docker/pulls/pangeo/pangeo-notebook?sort=date)
| [pytorch-notebook](pytorch-notebook/packages.txt) | pangeo-notebook + GPU-enabled pytorch | ![](https://img.shields.io/docker/image-size/pangeo/pytorch-notebook?sort=date) | ![](https://img.shields.io/docker/pulls/pangeo/pytorch-notebook?sort=date)
| [ml-notebook](ml-notebook/packages.txt) | pangeo-notebook + GPU-enabled tensorflow2 | ![](https://img.shields.io/docker/image-size/pangeo/ml-notebook?sort=date) | ![](https://img.shields.io/docker/pulls/pangeo/ml-notebook?sort=date)
| [forge](ml-notebook/packages.txt) | pangeo-notebook + [Apache Beam](https://beam.apache.org/) support| ![](https://img.shields.io/docker/image-size/pangeo/forge?sort=date) | ![](https://img.shields.io/docker/pulls/pangeo/forge?sort=date)

*Click on the image name in the table above for a current list of installed packages and versions*

```mermaid
graph TD;
    base-image-->base-notebook;
    base-notebook-->pangeo-notebook;
    pangeo-notebook-->pytorch-notebook;
    pangeo-notebook-->ml-notebook;
    pangeo-notebook-->forge;
    click base-image "https://hub.docker.com/r/pangeo/base-image" "Open this in a new tab" _blank
    click base-notebook "https://hub.docker.com/r/pangeo/base-notebook" "Open this in a new tab" _blank
    click pangeo-notebook "https://hub.docker.com/r/pangeo/pangeo-notebook" "Open this in a new tab" _blank
    click pytorch-notebook "https://hub.docker.com/r/pangeo/pytorch-notebook" "Open this in a new tab" _blank
    click ml-notebook "https://hub.docker.com/r/pangeo/ml-notebook" "Open this in a new tab" _blank
    click forge "https://hub.docker.com/r/pangeo/forge" "Open this in a new tab" _blank
```

### How to use the pangeo-notebook image with Binder
A major use-case for these images is running an ephemeral server on the Cloud with BinderHub. Anyone can launch a server running the latest-and-greatest `pangeo-notebook` image with the following URL

* https://mybinder.org/v2/gh/pangeo-data/pangeo-docker-images/HEAD?urlpath=lab

NOTE: the link above resolves to the [`pangeo-notebook` image](https://github.com/pangeo-data/pangeo-docker-images/tree/master/pangeo-notebook) and not `base-notebook`, `ml-notebook` or `pytorch-notebook` that are also defined in this repository. Currently BinderHubs map to a single image definition per repository.

#### Use nbgitpuller to automatically load content

The binder link above will launch Jupyterlab without any notebooks or other content. From Jupyterlab you can then upload notebooks or run `git pull` commands to retrieve content in another GitHub repository. However, it can be very useful to pre-load content when a server launches. [nbgitpuller link generator](https://jupyterhub.github.io/nbgitpuller/link) is very useful for this!

Below is a link to illustrate launching [`pangeo-notebook/2021.09.30`](https://github.com/pangeo-data/pangeo-docker-images/blob/2021.09.30/pangeo-notebook/packages.txt) and automatically pulling the notebooks housed in https://github.com/pangeo-data/cog-best-practices.

* https://mybinder.org/v2/gh/pangeo-data/pangeo-docker-images/2021.09.30?urlpath=git-pull%3Frepo%3Dhttps%253A%252F%252Fgithub.com%252Fpangeo-data%252Fcog-best-practices%26urlpath%3Dlab%252Ftree%252Fcog-best-practices%252F%26branch%3Dmain

#### Customize your environment
Advanced users may want a highly customized environment that still works on Pangeo BinderHubs. You can do that by building off the pangeo `base-image` following our [template repository example](https://github.com/pangeo-data/pangeo-binder-template). Further documentation on the configuration files in the `binder` subfolder can be found in the [repo2docker documentation](https://repo2docker.readthedocs.io/en/latest/config_files.html#configuration-files).

### How to launch Jupyterlab locally with one of these images
```
docker run -it --rm -p 8888:8888 pangeo/pangeo-notebook:latest jupyter lab --ip 0.0.0.0
```
**NOTE:** images are mirrored on quay.io so you can also pull `quay.io/pangeo/pangeo-notebook:latest`

To access files from your local hard drive from within the Docker Jupyterlab, you need to use a Docker [volume mount](https://docs.docker.com/storage/volumes/). The following command will mount your home directory in the docker container and launch the Jupyterlab from there.

```
docker run -it --rm --volume $HOME:$HOME -p 8888:8888 pangeo/pangeo-notebook:latest jupyter lab --ip 0.0.0.0 $HOME
```

You can also run commands other than `jupyter` when starting a Docker container:

```
docker run -it --rm pangeo/base-notebook:2021.09.30 /bin/bash
```

If you're doing Machine Learning and want to use NVIDIA GPUs,
follow the instructions at https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
to install `nvidia-docker`, and then start the Docker container like so:

```
docker run -it --rm --gpus all -p 8888:8888 pangeo/pytorch-notebook:master jupyter lab --ip 0.0.0.0
```

### How to launch an image with a Cloud provider on your own account

Many Cloud providers offer services to run Docker containers in their data centers.
Instructions will vary, so we don't provide specifics here, but as an example,
check out these docs for running containers on the cloud via Docker Compose:

- [Amazon Elastic Container Service (ECS)](https://docs.docker.com/cloud/ecs-integration)
- [Azure Container Instances (ACI)](https://docs.docker.com/cloud/aci-integration)

#### GitHub Codespaces (Azure)

You can launch the pangeo-notebook environment via [GitHub Codespaces](https://github.com/features/codespaces) with this button:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/pangeo-data/pangeo-docker-images?quickstart=1)


### How to install just the conda environment

If you're used to managing conda environments on your personal computer, or running a hosted JupyterLab service like [Google Colab](https://colab.research.google.com) or [AWS SageMaker Studio Lab](https://studiolab.sagemaker.aws), you can exactly match a tagged pangeo-notebook conda environment. For example, below we install the `pangeo-notebook` environment tagged on `2021.12.02`:

```
%conda create -n pangeo-notebook --file https://raw.githubusercontent.com/pangeo-data/pangeo-docker-images/2021.12.02/pangeo-notebook/conda-linux-64.lock
```
Note that this will only work on linux environments, since `conda-linux-64.lock` is specific to linux.

### Image tagging and "continuous building"
This repository uses [GitHub Actions](https://help.github.com/en/actions) to build images, run tests, and push images to [DockerHub](https://hub.docker.com/orgs/pangeo).

* Pull requests from forks trigger rebuilding all images

* `pangeo/base-notebook:master` corresponds to current "staging" image in sync with master branch. Built with every commit to master. Also tagged with short GitHub short SHA `pangeo/base-notebook:2639bd3`.

* Tags pushed to GitHub manually represent "production" releases with corresponding tags on DockerHub `pangeo/pangeo-notebook:2020.03.11`. The `latest` tag also corresponds to the most recent GitHub tag.


### How to build images through CI
A common need is to update conda package versions in these images. To do so simply, 1) Fork this repo, 2) edit `pangeo-notebook/environment.yml` on your fork, 3) create a PR. Compatible packages versions with `conda-lock` and a lock file is automatically committed added as a commit in your PR.


### How to build images locally
You'll need at least Conda installed, and Docker if you want to build and test locally.
```
# create a fork of this repo and clone it locally
git clone https://github.com/mygithub/pangeo-docker-images
cd pangeo-docker-images
# Install conda-lock
conda env create -f environment-condalock.yml
git checkout -b change-pangeo-notebook
```

Edit `pangeo-notebook/environment.yml` to change packages! Note that `make pangeo-notebook` is a convenient shortcut to build and test. See the Makefile for specific commands that are run. For example, you can just run conda-lock and don't have to run Docker to build and test locally.
```
make pangeo-notebook
git commit -a -m "added x packages, changed x version"
git push
# go to github to create PR, or use github cli https://cli.github.com
```

### Design:

##### Goals:
  1. compatible with [Pangeo BinderHubs](https://github.com/pangeo-data/pangeo-binder) and [JupyterHubs](https://github.com/pangeo-data/pangeo-cloud-federation)
  1. compatible with [Repo2Docker Python configuration files](https://repo2docker.readthedocs.io/en/latest/config_files.html)
  1. reproducible build process and explicit conda package lists
  1. small size, fast build
  1. easy to customize

Everything stems from the `Dockerfile` in the `base-image` folder. The `base-image` configures default settings for Conda and Dask with `condarc.yml` and `dask_config.yml` files. The `base-image` is not meant to run on its own, it is the common foundation for `-notebook` images that install Python packages including JupyerLab and lab extensions. Lists of Conda packages for each image are specified in an `environment.yml` in each `-notebook` folder, and compatible Dask and Jupyter packages are guaranteed by specifying the `pangeo-notebook` [conda metapackage](https://github.com/conda-forge/pangeo-notebook-feedstock).

You can pre-solve for compatible environments locally with [conda-lock](https://github.com/mariusvniekerk/conda-lock/blob/master/README.md) to convert the `environment.yml` file to a [conda-linux-64.lock](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#building-identical-conda-environments) file which is an explicit list of compatible packages solved by Conda. The major advantage of doing this is that if you rebuild at a later date the resulting Conda environment is identical, which improves reproducibility. For this reason, when building off of the `base-image`, any existing `conda-linux-64.lock` file takes precedence over the `environment.yml` file.

### Environment

The runtime environment sets two variables by default

1. `$PANGEO_ENV`: name of the conda environment.
2. `$PANGEO_SCRATCH`: a URL like `gcs://pangeo-scratch/username/` that
   points to a cloud storage bucket for temporary storage. This is set
   if the variable `$PANGEO_SCRATCH_PREFIX` and `JUPYTERHUB_USER`
   are detected. The prefix should be like `s3://pangeo-scratch`.
   This is not present in the `forge/` image.


### Other notes

* Since 2020.10.16, [mamba](https://github.com/mamba-org/mamba) is installed into the base-image and conda-lock environment and is used by default to solve for a compatible environment (see #146)
* For a simple list of packages for a given image, you can use a link like this: https://github.com/pangeo-data/pangeo-docker-images/blob/2020.10.08/pangeo-notebook/packages.txt
* To compare changes between two images, you can use a link like this: https://github.com/pangeo-data/pangeo-docker-images/compare/2020.10.03..2020.10.08
* Our `ml-notebook` image now contains JAX and TensorFlow with XLA enabled. Due to licensing issues, conda-forge does not have `ptxas`, but `ptxas` is needed for XLA to work correctly. Should you like to use JAX and/or TensorFlow with XLA optimization, please install `ptxas` on your own, for example, by `conda install -c nvidia cuda-nvcc`. At the time of writing (October 2022), JAX throws a compilation error if the `ptxas` version is higher than the driver version. There does not exist an easy solution for K80 GPUs, but in the case of T4 GPUs, you should install `conda install -c nvidia cuda-nvcc==11.6.*` to be safe. Alternatively for any GPU, you could set an environment variable to resolve the error caused by JAX: `XLA_FLAGS="--xla_gpu_force_compilation_parallelism=1"`. The aforementioned error will be removed (and likely turned into a warning) in a future version of JAX. See https://github.com/google/jax/issues/12776#issuecomment-1276649134


### Dask-gateway compatibility

The primary use of these Docker images is running on Pangeo Cloud deployments with [dask-gateway](https://github.com/dask/dask-gateway). Generally, the dask-gateway library version built into the image must match the dask-gateway version deployed in the cloud environment. The follow table keeps track of the first time a new dask-gateway version appears in a tagged image:

| dask-gateway |  Image tag  |
|--------------|-------------|
| 0.9          | 2020.11.06  |
| 0.8          | 2020.07.28  |
| 0.7          | 2020.04.22  |
