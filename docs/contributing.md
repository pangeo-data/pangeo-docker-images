# Contributing

## How to build images locally

You'll need at least Conda installed, and Docker if you want to build and test locally.

```
# create a fork of this repo and clone it locally
git clone https://github.com/mygithub/datalabs-docker-images
cd datalabs-docker-images
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

## How to build images through CI

A common need is to update conda package versions in these images. To do so simply, 1) Fork this repo, 2) edit `pangeo-notebook/environment.yml` on your fork, 3) create a PR. Compatible packages versions with `conda-lock` and a lock file is automatically committed added as a commit in your PR.

## Image tagging and "continuous building"

This repository uses [GitHub Actions](https://help.github.com/en/actions) to build images, run tests, and push images to [DockerHub](https://hub.docker.com/orgs/pangeo).

* Pull requests from forks trigger rebuilding all images

* `cnes/base-notebook:master` corresponds to current "staging" image in sync with master branch. Built with every commit to master. Also tagged with short GitHub short SHA `cnes/base-notebook:2639bd3`.

* Tags pushed to GitHub manually represent "production" releases with corresponding tags on DockerHub `cnes/pangeo-notebook:2020.03.11`. The `latest` tag also corresponds to the most recent GitHub tag.
