FROM ubuntu:18.04
# Master build file for pangeo images!

# Run this section as root
# ========================

# Environment variables
ENV CONDA_VERSION=4.7.12.1
ENV NB_USER=jovyan
ENV NB_UID=1000
ENV SHELL /bin/bash
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV CONDA_DIR /srv/conda
ENV NB_PYTHON_PREFIX ${CONDA_DIR}/envs/pangeo
ENV USER ${NB_USER}
ENV HOME /home/${USER}

# Copy auxiliary files
COPY start dask_config.yml condarc ${HOME}/

WORKDIR ${HOME}

# Apt Packages
RUN apt-get update --fix-missing \
    && apt-get install wget -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create group + user, and set proper permissions on home & conda directories
RUN groupadd \
        --gid ${NB_UID} \
        ${NB_USER}  \
    && useradd \
        --comment "Default user" \
        --create-home \
        --gid ${NB_UID} \
        --no-log-init \
        --shell /bin/bash \
        --uid ${NB_UID} \
        ${NB_USER}

# Move things around filesystem
RUN mkdir ${CONDA_DIR} \
    && chmod +x start \
    && cp start /srv/start \
    && mkdir -p ${NB_PYTHON_PREFIX}/etc/dask \
    && cp dask_config.yml ${NB_PYTHON_PREFIX}/etc/dask/dask.yml \
    && cp condarc ${CONDA_DIR}/.condarc \
    && ln -s ${CONDA_DIR}/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && chown -R ${NB_USER}:${NB_USER} /srv \
    && chown -R ${NB_USER}:${NB_USER} ${HOME}

# Only run these if used as a base image
# ----------------------
ONBUILD USER root
ONBUILD COPY . ${HOME}
ONBUILD RUN [ -d binder ] && cd binder \
        ; if test -f "apt.txt" ; then \
        apt-get update --fix-missing \
        && xargs -a apt.txt apt-get install -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        ; fi
ONBUILD RUN chown -R ${NB_USER}:${NB_USER} ${HOME}
# ----------------------


# Run this section as unprivileged jovyan
# ==========
USER ${NB_USER}

# Install miniconda and configure conda to activate 'pangeo' evironment by default
# NOTE: could use conda 4.8.2 with `conda update -n base -c defaults conda`
RUN export PATH=${CONDA_DIR}/bin:$PATH \
    && wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ${HOME}/miniconda.sh \
    && /bin/bash ~/miniconda.sh -u -b -p ${CONDA_DIR} \
    && rm ${HOME}/miniconda.sh \
    && conda clean -afy \
    && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete


# Only run if used as a base image
# ----------------------
ONBUILD USER ${NB_USER}

# Create "pangeo" environment from environment.yml
# Get pangeodask version from environment.yml
# NOTE: not sure if we need to pin pangeo-dask and pangeo-notebook images 
ONBUILD RUN [ -d binder ] && cd binder \
        ; if test -f "environment.yml" ; then \
        export PATH=${CONDA_DIR}/bin:$PATH \
        && conda env create -f environment.yml \
        && grep pangeo-dask environment.yml | awk '{print $NF}' > ${CONDA_DIR}/envs/pangeo/conda-meta/pinned \
        && grep pangeo-notebook environment.yml | awk '{print $NF}' > ${CONDA_DIR}/envs/pangeo/conda-meta/pinned \
        && echo "conda activate pangeo" >> ${CONDA_DIR}/etc/profile.d/conda.sh \
        && conda clean -afy \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
#        && find ${NB_PYTHON_PREFIX}/lib/python*/site-packages/bokeh/server/static -follow -type f -name '*.js' ! -name '*.min.js' -delete \
        ; fi

# Run postBuild script within "pangeo" environment
ONBUILD RUN [ -d binder ] && cd binder \
        ; if test -f "postBuild" ; then \
        export PATH=${NB_PYTHON_PREFIX}/bin:$PATH \
        && chmod +x postBuild \
        && ./postBuild \
        && rm -rf ${HOME}/.cache ${HOME}/.npm ${HOME}/.yarn \
        && rm -rf ${NB_PYTHON_PREFIX}/share/jupyter/lab/staging \
        && find ${NB_PYTHON_PREFIX} -follow -type f -name '*.js.map' -delete \
        ; fi

# Overwrite start entrypoint script if present
ONBUILD RUN [ -d binder ] && cd binder \
        ; if test -f "start" ; then \
        chmod +x start \
        && cp start /srv/start \
        ; fi
# ----------------------

EXPOSE 8888

ENTRYPOINT ["/srv/start"]
#CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
