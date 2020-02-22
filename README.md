# pangeo-stacks-dev

![Action Status](https://github.com/pangeo-data/pangeo-stacks-dev/workflows/StagingBuild/badge.svg) ![Action Status](https://github.com/pangeo-data/pangeo-stacks-dev/workflows/ProductionBuild/badge.svg)

An experiment to simplify pangeo docker images
See: https://github.com/pangeo-data/pangeo-stacks/issues/125

### Image tagging
https://hub.docker.com/orgs/pangeodev

* `pangeodev/base-image:latest` is always most recent production image. Also tagged with date and github SHA from prod branch pangeodev/base-image/2020.02.21-2639bd3`. 

* `pangeodev/base-image:staging` corresponds to current staging image. Also tagged with a snapshot of date and github SHA from staging branch `pangeodev/base-image/202002210409454957bb` - {YEAR}{MONTH}{DAY}{HOUR}{MINUTE}{SECOND}{first 6 digits of the git sha}.


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
docker build -t pangeodev/pangeo-image:staging .
```
