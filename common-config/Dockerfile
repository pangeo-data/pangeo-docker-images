FROM ubuntu:18.04

# RUN this section as root
# -----
ARG CONDA_VERSION=4.7.12
ARG NB_USER=jovyan
ARG NB_UID=1000

# Environment variables
ENV SHELL /bin/bash
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV APP_BASE /srv
ENV CONDA_DIR ${APP_BASE}/conda
ENV KERNEL_PYTHON_PREFIX ${CONDA_DIR}
ENV NB_PYTHON_PREFIX ${CONDA_DIR}
ENV PATH ${CONDA_DIR}/bin:$PATH
ENV USER ${NB_USER}
ENV HOME /home/${USER}
ENV REPO_DIR ${HOME}

# Do everything in /srv since /home/jovyan can be mounted by nfs
WORKDIR ${APP_BASE}

# Copy auxiliary files
COPY . ${APP_BASE}

# Apt.txt Packages
RUN apt-get update --fix-missing \
    && xargs -a apt.txt apt-get install -y \
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
        ${NB_USER} \
    && mkdir ${CONDA_DIR} \
    && ln -s ${CONDA_DIR}/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && cp repo2docker-entrypoint /usr/local/bin/repo2docker-entrypoint

RUN chown -R ${NB_USER}:${NB_USER} ${CONDA_DIR} \
    && chown -R ${NB_USER}:${NB_USER} ${HOME}


# RUN this section as NB_USER
# -----
USER ${NB_USER}

# Install miniconda and configure conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -u -b -p ${CONDA_DIR} \
    && rm ~/miniconda.sh \
    && ${CONDA_DIR}/bin/conda clean -afy \
    && ${CONDA_DIR}/bin/conda config --add channels conda-forge \
    && ${CONDA_DIR}/bin/conda config --set channel_priority strict \
    && ${CONDA_DIR}/bin/conda config --system --set show_channel_urls true \
    && echo "conda activate notebook" >> ${CONDA_DIR}/etc/profile.d/conda.sh \
    && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete

# Conda "notebook" environment and cleanup
RUN conda env create -f environment.yml \
    && conda clean -afy \
    && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
    && find ${CONDA_DIR}/envs/notebook/lib/python*/site-packages/bokeh/server/static -follow -type f -name '*.js' ! -name '*.min.js' -delete

# PostBuild
ENV PATH ${CONDA_DIR}/envs/notebook/bin:$PATH
RUN ./postBuild \
    && mkdir -p ${KERNEL_PYTHON_PREFIX}/etc/dask \
    && cp dask_config.yaml ${KERNEL_PYTHON_PREFIX}/etc/dask/dask.yaml \
    && rm -rf ${HOME}/.cache ${HOME}/.npm ${HOME}/.yarn \
    && rm -rf ${KERNEL_PYTHON_PREFIX}/share/jupyter/lab/staging \
    && find ${KERNEL_PYTHON_PREFIX} -follow -type f -name '*.js.map' -delete

EXPOSE 8888
WORKDIR ${HOME}

ENTRYPOINT ["/usr/local/bin/repo2docker-entrypoint"]
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
