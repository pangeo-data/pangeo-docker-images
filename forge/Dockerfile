ARG PANGEO_BASE_IMAGE_TAG=master
# Apache Beam requires the following to exist in docker images used to run beam
# workloads:
# 1. The apache-beam python package, with appropriate extras (for example, [gcp] if we
#    we want to accss google cloud services)
# 2. A 'beam boot' executable binary set as the entrypoint. This is a go program that
#    actually launches the appropriate python code.
#
# These two need to be the same version to avoid any possible incompatibilites.
#
# In this image, we install the python package via pip (as the conda version seems currently
# broken), and bring in the built go binary from the upstream docker image.
# This ensures we meet the requirements needed for running beam while still
# reusing most of the pre-existing infra we have for maintaining images.

# ONBUILD instructions in base-image/Dockerfile are used to
# perform certain actions based on the presence of specific
# files (such as conda-linux-64.lock, start) in this repo.
# Refer to the base-image/Dockerfile for documentation.
FROM pangeo/base-image:${PANGEO_BASE_IMAGE_TAG}

# Copy *just* the golang based boot binary from the beam sdk image, *not*
# the entire python package they build there. We install the python bits ourselves.
# The version used here *must* match the version of `apache-beam[gcp]` in the
# accompanying `environment.yml` file
COPY --from=apache/beam_python3.9_sdk:2.40.0 /opt/apache/beam/boot /opt/apache/beam/boot

# Unfortunately, it looks like GCP DataFlow requires containers be run as root -
# it mounts some folders into /var/opt/ and expects them to be writeable as root :(
# This shouldn't affect Jupyter use cases as they often set uid explicitly anyway.
USER root