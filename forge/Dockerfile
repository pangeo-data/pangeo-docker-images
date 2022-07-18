FROM golang:1.18-bullseye

ARG BEAM_VERSION=2.40.0

RUN curl -sSL https://github.com/apache/beam/archive/refs/tags/v${BEAM_VERSION}.tar.gz | tar -xzf -

RUN cd beam-${BEAM_VERSION}/sdks/python/container && \
    CGO_ENABLED=0 go build -o /beam-boot

# ONBUILD instructions in base-image/Dockerfile are used to
# perform certain actions based on the presence of specific
# files (such as conda-linux-64.lock, start) in this repo.
# Refer to the base-image/Dockerfile for documentation.
FROM pangeo/base-image:master

ARG BEAM_VERSION=2.40.0

# Install this here so the version of boot matches the version of the python package
RUN pip install --no-cache apache-beam[gcp]==${BEAM_VERSION}

COPY --from=0 /beam-boot /usr/local/bin/boot
