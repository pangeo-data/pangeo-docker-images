# Dockerfile for base image of all pangeo images
FROM ubuntu:20.04
# build file for pangeo images

LABEL org.opencontainers.image.source=https://github.com/pangeo-data/pangeo-docker-images

# Run this section as root
ENV CONDA_ENV=notebook \
    NB_USER=jovyan \
    NB_UID=1000 \
    SHELL=/bin/bash \
    LANG=C.UTF-8  \
    LC_ALL=C.UTF-8 \
    CONDA_DIR=/srv/conda

ENV NB_PYTHON_PREFIX=${CONDA_DIR}/envs/${CONDA_ENV} \
    DASK_ROOT_CONFIG=${CONDA_DIR}/etc \
    HOME=/home/${NB_USER}

ENV PATH=${NB_PYTHON_PREFIX}/bin:${CONDA_DIR}/bin:${PATH}

# required for prefect agent: https://github.com/PrefectHQ/prefect/issues/3061
ENV DEBIAN_FRONTEND=noninteractive

# Create jovyan user, permissions, add conda init to startup script
RUN echo "Creating ${NB_USER} user..." \
    && groupadd --gid ${NB_UID} ${NB_USER}  \
    && useradd --create-home --gid ${NB_UID} --no-log-init --uid ${NB_UID} ${NB_USER} \
    && echo ". ${CONDA_DIR}/etc/profile.d/conda.sh ; conda activate ${CONDA_ENV}" > /etc/profile.d/init_conda.sh \
    && chown -R ${NB_USER}:${NB_USER} /srv

# SEE: https://github.com/phusion/baseimage-docker/issues/58
ARG DEBIAN_FRONTEND=noninteractive

RUN echo "Installing Apt-get packages..." \
    && apt-get update --fix-missing > /dev/null \
    && apt-get install -y apt-utils wget zip tzdata > /dev/null \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# ========================

USER ${NB_USER}
WORKDIR ${HOME}

RUN echo "Installing Mambaforge..." \
    && URL="https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh" \
    && wget --quiet ${URL} -O installer.sh \
    && /bin/bash installer.sh -u -b -p ${CONDA_DIR} \
    && rm installer.sh \
    && mamba clean -afy \
    && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete

EXPOSE 8888
ENTRYPOINT ["/srv/start"]
#CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]

# We use ONBUILD (https://docs.docker.com/engine/reference/builder/#onbuild)
# to support triggering certain behavior when specific files exist in the directories of our
# child images (such as base-notebook, pangeo-notebook, etc). This is
# to *mimic* the repo2docker behavior, where users can just add
# environment.yml, requirements.txt, apt.txt etc files to get certain
# behavior without having to understand how Dockerfiles work. We use
# ONBUILD to support a subset of the files that repo2docker supports.
# We do not use repo2docker itself here, to make the images much smaller
# and easier to reason about.
# ----------------------
ONBUILD USER root
# FIXME (?): user and home folder is hardcoded for now
# FIXME (?): this line breaks the cache of all steps below
ONBUILD COPY --chown=jovyan:jovyan . /home/jovyan

# repo2docker will load files from a .binder or binder directory if
# present. We check if those directories exist, and print a diagnostic
# message here.
ONBUILD RUN echo "Checking for 'binder' or '.binder' subfolder" \
        ; if [ -d binder ] ; then \
        echo "Using 'binder/' build context" \
        ; elif [ -d .binder ] ; then \
        echo "Using '.binder/' build context" \
        ; else \
        echo "Using './' build context" \
        ; fi

# Install apt packages specified in a apt.txt file if it exists.
# Unlike repo2docker, blank lines nor comments are supported here.
ONBUILD RUN echo "Checking for 'apt.txt'..." \
        ; [ -d binder ] && cd binder \
        ; [ -d .binder ] && cd .binder \
        ; if test -f "apt.txt" ; then \
        apt-get update --fix-missing > /dev/null \
        && xargs -a apt.txt apt-get install -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        ; fi

# If a jupyter_notebook_config.py exists, copy it to /etc/jupyter so
# it will be read by jupyter processes when they start. This feature is
# not available in repo2docker.
ONBUILD RUN echo "Checking for 'jupyter_notebook_config.py'..." \
        ; [ -d binder ] && cd binder \
        ; [ -d .binder ] && cd .binder \
        ; if test -f "jupyter_notebook_config.py" ; then \
        mkdir -p /etc/jupyter \
        && cp jupyter_notebook_config.py /etc/jupyter \
        ; fi

ONBUILD USER ${NB_USER}

# We want to keep our images as reproducible as possible. If a lock
# file with exact versions of all required packages is present, we use
# it to install packages. conda-lock (https://github.com/conda-incubator/conda-lock)
# is used to generate this conda-linux-64.lock file from a given environment.yml
# file - so we get the exact same versions each time the image is built. This
# also lets us see what packages have changed between two images by diffing
# the contents of the lock file between those image versions.
# If a lock file is not present, we use the environment.yml file. And
# if that is also not present, we use the pangeo-notebook conda-forge
# package (https://anaconda.org/conda-forge/pangeo-notebook) to install
# a list of base packages.
# After installing the packages, we cleanup some unnecessary files
# to try reduce image size - see https://jcristharif.com/conda-docker-tips.html
ONBUILD RUN echo "Checking for 'conda-linux-64.lock' or 'environment.yml'..." \
        ; [ -d binder ] && cd binder \
        ; [ -d .binder ] && cd .binder \
        ; if test -f "conda-linux-64.lock" ; then \
        mamba create --name ${CONDA_ENV} --file conda-linux-64.lock \
        ; elif test -f "environment.yml" ; then \
        mamba env create --name ${CONDA_ENV} -f environment.yml  \
        ; else echo "No conda-linux-64.lock or environment.yml! *creating default env*" ; \
        mamba create --name ${CONDA_ENV} pangeo-notebook \
        ; fi \
        && mamba clean -yaf \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
        ; if [ -d ${NB_PYTHON_PREFIX}/lib/python*/site-packages/bokeh/server/static ]; then \
        find ${NB_PYTHON_PREFIX}/lib/python*/site-packages/bokeh/server/static -follow -type f -name '*.js' ! -name '*.min.js' -delete \
        ; fi

# If a requirements.txt file exists, use pip to install packages
# listed there. We don't want to save cached wheels in the image
# to avoid wasting space.
ONBUILD RUN echo "Checking for pip 'requirements.txt'..." \
        ; [ -d binder ] && cd binder \
        ; [ -d .binder ] && cd .binder \
        ; if test -f "requirements.txt" ; then \
        ${NB_PYTHON_PREFIX}/bin/pip install --no-cache-dir -r requirements.txt \
        ; fi

# If a postBuild file exists, run it!
# After it's done, we try to remove any possible cruft commands there
# leave behind under $HOME - particularly stuff that jupyterlab extensions
# leave behind.
ONBUILD RUN echo "Checking for 'postBuild'..." \
        ; [ -d binder ] && cd binder \
        ; [ -d .binder ] && cd .binder \
        ; if test -f "postBuild" ; then \
        chmod +x postBuild \
        && ./postBuild \
        && rm -rf /tmp/* \
        && rm -rf ${HOME}/.cache ${HOME}/.npm ${HOME}/.yarn \
        && rm -rf ${NB_PYTHON_PREFIX}/share/jupyter/lab/staging \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
        ; fi

# If a start file exists, put that under /srv/start. Used in the
# same way as a start file in repo2docker.
ONBUILD RUN echo "Checking for 'start'..." \
        ; [ -d binder ] && cd binder \
        ; [ -d .binder ] && cd .binder \
        ; if test -f "start" ; then \
        chmod +x start \
        && cp start /srv/start \
        ; fi
# ----------------------
