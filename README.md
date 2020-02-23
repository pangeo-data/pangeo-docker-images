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


### Test these images on binderhub
https://github.com/scottyhq/pangeodev-binder

### To run locally
```
docker pull pangeodev/base-image:latest
docker run -it --name repo2docker -p 8888:8888 pangeodev/base-image:latest jupyter lab --ip 0.0.0.0
docker stop repo2docker
docker rm repo2docker
```

### To build locally
(pangeo-image)
```
git clone https://github.com/pangeo-data/pangeo-stacks-dev
cd pangeo-stacks-dev
rsync -a -v --ignore-existing base-image/* pangeo-image/
cd pangeo-image
docker build -t pangeodev/pangeo-image:test .
```
