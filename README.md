# pangeo-stacks-dev

![Action Status](https://github.com/pangeo-data/pangeo-stacks-dev/workflows/Staging/badge.svg) ![Action Status](https://github.com/pangeo-data/pangeo-stacks-dev/workflows/Production/badge.svg)

An experiment to simplify Pangeo docker images
See: https://github.com/pangeo-data/pangeo-stacks/issues/125

Goals:
1) compatibility with Pangeo BinderHubs and JupyterHubs
2) small size, fast build
3) easy to customize
4) compatibility with Repo2Docker sidecar files (apt.txt, environment.yml, postBuild, start)

Design:
Everything stems from the `Dockerfile` defining the base-image. Once built, all other images use a simple Dockerfile in the repository root to run ONBUILD commands on the base-image (`FROM pangeodev/base-image:2020.02.27` is all you need!). We then create `base-worker` images that do not have JupyterLab UI packages installed but do have dask packages pinned by a `pangeo-dask` conda metapackage https://github.com/pangeo-data/conda-metapackages. `base-notebook` has JupyerLab UI packages and extensions installed and is consequently much larger in size:
```
pangeodev/base-notebook     2020.02.27          418a793a9970        21 minutes ago      894MB
pangeodev/base-worker       2020.02.27          f4a634c69cdf        26 seconds ago      581MB
pangeodev/base-image        2020.02.27          5b36a380a27c        26 minutes ago      204MB
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
cd base-image
docker build -t pangeodev/base-image:2020.02.27 .
cd ../
echo "FROM pangeodev/base-image:2020.02.27" > Dockerfile
cd base-notebook
docker build -t pangeodev/pangeo-image:2020.02.27 -f ../Dockerfile .
cd ../
docker run -v $PWD:/home/jovyan pangeodev/pangeo-image:2020.02.27 ./run_tests.sh
```


### Image descriptions
```
base-image/      master Dockerfile for building images, conda and filesystem configured

base-worker/     minimal dask worker config, no jupyterlab packages
base-notebook/   minimally functional image for pangeo jupyterhub notebooks

pangeo-worker/   dask worker config with analysis packages, no jupyterlab packages
pangeo-notebook/ image for jupyterlab with consistent dask and analysis packages

pangeo-ml/ on hold...
```
