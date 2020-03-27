FROM ubuntu:18.04
# Master build file for pangeo images

# Run this section as root
# ========================
ENV CONDA_VERSION=4.7.12.1 \
    NB_USER=jovyan \
    NB_UID=1000 \
    SHELL=/bin/bash \
    LANG=C.UTF-8  \
    LC_ALL=C.UTF-8 \
    CONDA_DIR=/srv/conda

ENV NB_PYTHON_PREFIX=${CONDA_DIR}/envs/pangeo \
    DASK_ROOT_CONFIG=${CONDA_DIR}/etc \
    HOME=/home/${NB_USER} \
    PATH=${CONDA_DIR}/bin:${PATH}

# Create jovyan user, permissions, add conda init to startup script
RUN echo "Creating ${NB_USER} user..." \
    && groupadd --gid ${NB_UID} ${NB_USER}  \
    && useradd --create-home --gid ${NB_UID} --no-log-init --uid ${NB_UID} ${NB_USER} \
    && echo ". ${CONDA_DIR}/etc/profile.d/conda.sh ; conda activate pangeo" > /etc/profile.d/init_conda.sh \
    && chown -R ${NB_USER}:${NB_USER} /srv

# COPY chown available docker>17.09
# but env sub only works for docker>19.03 (kubernetes>1.17)
# https://github.com/moby/moby/issues/35018
#COPY --chown=${NB_USER}:${NB_USER} . ${HOME}
COPY --chown=jovyan:jovyan . /srv

RUN echo "Installing Apt-get packages..." \
    && apt-get update --fix-missing \
    && apt-get install wget -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# ========================

USER ${NB_USER}
WORKDIR ${HOME}

# NOTE: could use conda 4.8.2 with `conda update -n base -c defaults conda`
RUN echo "Installing Miniconda3..." \
    && wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh \
    && /bin/bash miniconda.sh -u -b -p ${CONDA_DIR} \
    && rm miniconda.sh \
    && mv /srv/condarc ${CONDA_DIR}/.condarc \
    && mv /srv/dask_config.yml ${CONDA_DIR}/etc/dask.yml \
    && conda clean -afy \
    && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete

EXPOSE 8888
ENTRYPOINT ["/srv/start"]
#CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]

# Only run these if used as a base image
# ----------------------
ONBUILD USER root
# hardcode for now
ONBUILD COPY --chown=jovyan:jovyan . /home/jovyan

ONBUILD RUN echo "Checking for 'apt.txt'..." \
        ; [ -d binder ] && cd binder \
        ; if test -f "apt.txt" ; then \
        apt-get update --fix-missing \
        && xargs -a apt.txt apt-get install -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        ; fi

ONBUILD USER ${NB_USER}

# Create "pangeo" conda environment and dask labextensions
ONBUILD RUN echo "Checking for conda 'spec-file.txt' or 'environment.yml'..." \
        ; [ -d binder ] && cd binder \
        ; if test -f "spec-file.txt" ; then \
        conda create --name pangeo --file spec-file.txt \
        ; elif test -f "environment.yml" ; then \
        conda env create -f environment.yml  \
        ; else echo "No spec-file.txt or environment.yml! *creating default env*" ; \
        conda create --name pangeo pangeo-notebook=0.0.2 \
        ; fi \
        && conda clean -yaf \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
        && find ${NB_PYTHON_PREFIX}/lib/python*/site-packages/bokeh/server/static -follow -type f -name '*.js' ! -name '*.min.js' -delete

# Install pip packages
# remove cache https://github.com/pypa/pip/pull/6391 ?
ONBUILD RUN echo "Checking for pip 'requirements.txt'..." \
        ; [ -d binder ] && cd binder \
        ; if test -f "requirements.txt" ; then \
        ${CONDA_DIR}/envs/pangeo/bin/pip install --no-cache-dir -r requirements.txt \
        ; fi

# Run postBuild script within "pangeo" environment
ONBUILD RUN echo "Checking for 'postBuild'..." \
        ; [ -d binder ] && cd binder \
        ; if test -f "postBuild" ; then \
        export PATH=${CONDA_DIR}/envs/pangeo/bin:${PATH} \
        && chmod +x postBuild \
        && ./postBuild \
        && rm -r /tmp/* \
        && rm -rf ${HOME}/.cache ${HOME}/.npm ${HOME}/.yarn \
        && rm -rf ${NB_PYTHON_PREFIX}/share/jupyter/lab/staging \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
        ; fi

# Overwrite start entrypoint script if present
ONBUILD RUN echo "Checking for 'start'..." \
        ; [ -d binder ] && cd binder \
        ; if test -f "start" ; then \
        chmod +x start \
        && cp start /srv/start \
        ; fi
# ----------------------
