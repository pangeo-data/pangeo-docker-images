# pangeo-stacks-dev

An experiment to simplify pangeo docker images
See: https://github.com/pangeo-data/pangeo-stacks/issues/125

Images pushed to
https://hub.docker.com/orgs/pangeodev

comparison with repo2docker / old pangeo-stacks approach

* no dependencies or python packages to build (just docker)
* ubuntu:18.04 base image
* no freezing base environment or stacked conda environments
* keeps `base` environment from standard miniconda install
* but only use conda-forge channel in `notebook environment`
* higher level images update `notebook` environment with `conda env update -n notebook -f environment.yml --prune`
* still creates new docker layers in pangeo-image 
