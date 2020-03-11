# pangeo-stacks-dev

![Action Status](https://github.com/pangeo-data/pangeo-stacks-dev/workflows/Staging/badge.svg) ![Action Status](https://github.com/pangeo-data/pangeo-stacks-dev/workflows/Production/badge.svg)

An experiment to simplify Pangeo docker images
See: https://github.com/pangeo-data/pangeo-stacks/issues/125

Goals:
1) compatibility with Pangeo BinderHubs and JupyterHubs
2) smaller size, faster build
3) easy to customize
4) compatibility with Repo2Docker sidecar files (apt.txt, environment.yml, postBuild, start)

Design:
Everything stems from the `Dockerfile` in the `base-image` folder. The `base-image` installs a miniconda base environment and configures default settings for conda and dask with `condarc` and `dask_config.yml`. Compatible dask and jupyter packages are guaranteed by specifying the `pangeo-notebook` conda metapackage in `base-image/condarc` file. `-notebook` images run ONBUILD commands from the base-image to create JupyerLab UI packages and extensions installed and are consequently much larger in size:
```
pangeodev/ml-notebook       2020.03.11     4.83GB
pangeodev/pangeo-notebook   2020.03.11     1.92GB
pangeodev/base-notebook     2020.03.11     794MB
pangeodev/base-image        2020.03.11     204MB
```


### Image tagging and "continuous building"
https://hub.docker.com/orgs/pangeodev

* `pangeodev/base-notebook:latest` is always most recent production image. Tags pushed to GitHub also correspond to tags on dockerhub `pangeodev/base-image:0.0.1`

* `pangeodev/base-notebook:master` corresponds to current staging image in sync with master branch. Built with every commit to master. Also tagged with short github SHA `pangeodev/base-notebook:2639bd3`

* Pull requests automatically trigger building image but can't push to dockerhub b/c they don't have access to repo secrets for authentication

### Test BinderHub configuration
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
make base-image
make base-notebook
make pangeo-notebook
make ml-notebook
```


### Image descriptions
```
base-image/      master Dockerfile for building images, conda and filesystem configured
base-notebook/   minimally functional image for pangeo jupyterhub and binderhub notebooks
pangeo-notebook/ add core earth science analysis packages
ml-notebook/     add core earth science analysis packages and tensorflow2 (GPU-enabled)
```
