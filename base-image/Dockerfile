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
    HOME=/home/${NB_USER}

RUN groupadd --gid ${NB_UID} ${NB_USER}  \
    && useradd --create-home --gid ${NB_UID} --no-log-init --uid ${NB_UID} ${NB_USER} \
    && ln -s ${CONDA_DIR}/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && chown -R ${NB_USER}:${NB_USER} /srv

# Apt Packages
RUN apt-get update --fix-missing \
    && apt-get install wget -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# ========================

USER ${NB_USER}
WORKDIR ${HOME}
# Create jovyan group + user, and set necessary permissions
COPY  --chown=${NB_USER}:${NB_USER} . ${HOME}/

# Install miniconda and configure conda to activate 'pangeo' evironment by default
# NOTE: could use conda 4.8.2 with `conda update -n base -c defaults conda`
RUN export PATH=${CONDA_DIR}/bin:$PATH \
    && wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh \
    && /bin/bash miniconda.sh -u -b -p ${CONDA_DIR} \
    && rm miniconda.sh \
    && conda clean -afy \
    && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete

RUN cp condarc ${CONDA_DIR}/.condarc \
    && cp dask_config.yml ${CONDA_DIR}/etc/dask.yml \
    && cp start /srv/start

EXPOSE 8888
ENTRYPOINT ["/srv/start"]
#CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]

# Only run these if used as a base image
# ----------------------
ONBUILD USER root
ONBUILD COPY --chown=${NB_USER}:${NB_USER} . ${HOME}
ONBUILD RUN echo "Checking for 'apt.txt'..." \
        ; [ -d binder ] && cd binder \
        ; if test -f "apt.txt" ; then \
        apt-get update --fix-missing \
        && xargs -a apt.txt apt-get install -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        ; fi

ONBUILD USER ${NB_USER}

# Create "pangeo" conda environment
# NOTE: pin metapackage to avoid users install incompatible versions?
# https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#building-identical-conda-environments
ONBUILD RUN echo "Checking for 'packages.txt'..." \
        ; [ -d binder ] && cd binder \
        ; if test -f "packages.txt" ; then \
        export PATH=${CONDA_DIR}/bin:$PATH  \
        && conda create --name pangeo --file packages.txt \
#        ; else ; if test -f "environment.yml" ; then \
#        conda env create -f environment.yml  ; fi \
        && echo "conda activate pangeo" >> ${CONDA_DIR}/etc/profile.d/conda.sh \
        && conda clean -yaf \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
        && find ${NB_PYTHON_PREFIX}/lib/python*/site-packages/bokeh/server/static -follow -type f -name '*.js' ! -name '*.min.js' -delete \
        ; fi

# Install pip packages if any
# remove cache https://github.com/pypa/pip/pull/6391?
ONBUILD RUN echo "Checking for 'requirements.txt'..." \
        ; [ -d binder ] && cd binder \
        ; if test -f "requirements.txt" ; then \
        export PATH=${CONDA_DIR}/bin:$PATH \
        && pip install -r requirements.txt \
        ; fi

# Run postBuild script within "pangeo" environment
ONBUILD RUN echo "Checking for 'postBuild'..." \
        ; [ -d binder ] && cd binder \
        ; if test -f "postBuild" ; then \
        export PATH=${NB_PYTHON_PREFIX}/bin:$PATH \
        && chmod +x postBuild \
        && ./postBuild \
        && rm -rf ${HOME}/.cache ${HOME}/.npm ${HOME}/.yarn \
        && rm -rf ${NB_PYTHON_PREFIX}/share/jupyter/lab/staging \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
        && find ${NB_PYTHON_PREFIX} -follow -type f -name '*.js.map' -delete \
        ; fi

# Overwrite start entrypoint script if present
ONBUILD RUN echo "Checking for 'start'..." \
        ; [ -d binder ] && cd binder \
        ; if test -f "start" ; then \
        chmod +x start \
        && cp start /srv/start \
        ; fi
# ----------------------
