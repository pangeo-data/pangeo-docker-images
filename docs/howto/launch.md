# How to launch a notebook using these images

## How to use the `pangeo-notebook` image with Binder

A major use-case for these images is running an ephemeral server on the Cloud with BinderHub. Anyone can launch a server running the latest-and-greatest `pangeo-notebook` image with the following URL

* https://mybinder.org/v2/gh/cnes/datalabs-docker-images/HEAD?urlpath=lab

NOTE: the link above resolves to the [`pangeo-notebook` image](https://github.com/cnes/datalabs-docker-images/tree/master/pangeo-notebook) and not `base-notebook` or `pytorch-notebook` that are also defined in this repository. Currently BinderHubs map to a single image definition per repository.

### Use nbgitpuller to automatically load content

The binder link above will launch Jupyterlab without any notebooks or other content. From Jupyterlab you can then upload notebooks or run `git pull` commands to retrieve content in another GitHub repository. However, it can be very useful to pre-load content when a server launches. [nbgitpuller link generator](https://jupyterhub.github.io/nbgitpuller/link) is very useful for this!

Below is a link to illustrate launching [`pangeo-notebook/2021.09.30`](https://github.com/cnes/datalabs-docker-images/blob/2021.09.30/pangeo-notebook/packages.txt) and automatically pulling the notebooks housed in https://github.com/pangeo-data/cog-best-practices.

* https://mybinder.org/v2/gh/cnes/datalabs-docker-images/2021.09.30?urlpath=git-pull%3Frepo%3Dhttps%253A%252F%252Fgithub.com%252Fpangeo-data%252Fcog-best-practices%26urlpath%3Dlab%252Ftree%252Fcog-best-practices%252F%26branch%3Dmain

## How to launch Jupyterlab locally with one of these images

```
docker run -it --rm -p 8888:8888 cnes/pangeo-notebook:latest jupyter lab --ip 0.0.0.0
```

To access files from your local hard drive from within the Docker Jupyterlab, you need to use a Docker [volume mount](https://docs.docker.com/storage/volumes/). The following command will mount your home directory in the docker container and launch the Jupyterlab from there.

```
docker run -it --rm --volume $HOME:$HOME -p 8888:8888 cnes/pangeo-notebook:latest jupyter lab --ip 0.0.0.0 $HOME
```

You can also run commands other than `jupyter` when starting a Docker container:

```
docker run -it --rm cnes/base-notebook:2021.09.30 /bin/bash
```

If you're doing Machine Learning and want to use NVIDIA GPUs,
follow the instructions at https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
to install `nvidia-container-toolkit`, and then start the Docker container like so:

```
docker run -it --rm --gpus all -p 8888:8888 cnes/pytorch-notebook:master jupyter lab --ip 0.0.0.0
```

## How to launch an image with a Cloud provider on your own account

Many Cloud providers offer services to run Docker containers in their data centers.
Instructions will vary, so we don't provide specifics here, but as an example,
check out these docs for running containers on the cloud via Docker Compose:

- [Amazon Elastic Container Service (ECS)](https://docs.docker.com/cloud/ecs-integration)
- [Azure Container Instances (ACI)](https://docs.docker.com/cloud/aci-integration)

## GitHub Codespaces (Azure)

You can launch the pangeo-notebook environment via [GitHub Codespaces](https://github.com/features/codespaces) with this button:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/cnes/datalabs-docker-images?quickstart=1)
