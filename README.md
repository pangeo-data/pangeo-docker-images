# pangeo-stacks-dev

![Action Status](https://github.com/pangeo-data/pangeo-stacks-dev/workflows/Staging/badge.svg) ![Action Status](https://github.com/pangeo-data/pangeo-stacks-dev/workflows/Production/badge.svg)

| base-image | pangeo-image | ml-image |
|------------|--------------|----------|
| [![](https://images.microbadger.com/badges/image/pangeodev/base-image.svg)](https://microbadger.com/images/pangeodev/base-image "Get your own image badge on microbadger.com") |  [![](https://images.microbadger.com/badges/image/pangeodev/pangeo-image.svg)](https://microbadger.com/images/pangeodev/pangeo-image "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/pangeodev/ml-image.svg)](https://microbadger.com/images/pangeodev/ml-image "Get your own image badge on microbadger.com") |

An experiment to simplify pangeo docker images
See: https://github.com/pangeo-data/pangeo-stacks/issues/125

### Image tagging and "continuous building"
https://hub.docker.com/orgs/pangeodev

* `pangeodev/base-image:latest` is always most recent production image. Tags pushed to GitHub also correspond to tags on dockerhub `pangeodev/base-image:0.0.1`

* `pangeodev/base-image:master` corresponds to current staging image in sync with master branch. Built with every commit to master. Also tagged with short github SHA `pangeodev/base-image:2639bd3`

* Pull requests automatically trigger building image but can't push to dockerhub b/c they don't have access to repo secrets for authentication

### Base images use conda metapackages for dask and jupyter requirements
https://github.com/pangeo-data/conda-metapackages


### Test these images on binderhub
https://github.com/scottyhq/pangeodev-binder

### To run locally
```
docker pull pangeodev/base-notebook:latest
docker run -it --name repo2docker -p 8888:8888 pangeodev/base-notebook:latest jupyter lab --ip 0.0.0.0
docker stop repo2docker
docker rm repo2docker
```

### To build locally
(pangeo-image)
```
git clone https://github.com/pangeo-data/pangeo-stacks-dev
cd base-image
docker build -t pangeodev/pangeo-image:2020.02.27 .
# Change Dockerfile tag in repository root to match new image before building other images:
cd base-notebook
docker build -t pangeodev/pangeo-image:test -f ../Dockerfile .
```


### Image descriptions
```
base-image/      master Dockerfile for building images, also for basic dask workers
base-notebook/   minimally functional image for pangeo jupyterhub notebooks

pangeo-worker/   dask worker config with analysis packages, no jupyterlab packages
pangeo-notebook/ image for jupyterlab with consistent dask and analysis packages

pangeo-ml/ on hold...
```
