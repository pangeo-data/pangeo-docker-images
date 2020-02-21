# pangeo-stacks-dev

![Action Status](https://github.com/pangeo-data/pangeo-stacks-dev/workflows/StagingBuild/badge.svg) ![Action Status](https://github.com/pangeo-data/pangeo-stacks-dev/workflows/ProductionBuild/badge.svg)

An experiment to simplify pangeo docker images
See: https://github.com/pangeo-data/pangeo-stacks/issues/125

Images pushed to
https://hub.docker.com/orgs/pangeodev

### To run locally
```
docker pull pangeodev/base-image:latest
docker run -it --name repo2docker -p 8888:8888 pangeodev/base-image:latest jupyter lab --ip 0.0.0.0
docker stop repo2docker
docker rm repo2docker
```

### Test binderhub configuration
