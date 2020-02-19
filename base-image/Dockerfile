FROM continuumio/miniconda3:4.7.12

# RUN this section as root
# -----

# Let's try emulate the environment vars to repo2docker as much as we can
# CONDA_DIR is ${APP_BASE}/conda in repo2docker, but we already have it in /opt/conda here
ENV CONDA_DIR=/opt/conda
ENV APP_BASE=/srv

# We use the base existing conda env as our notebook env
# NOTE: I think we can only use NB_PYTHON_PREFIX?
ENV KERNEL_PYTHON_PREFIX=${CONDA_DIR}
ENV NB_PYTHON_PREFIX=${CONDA_DIR}
# Set up PATH
ENV PATH=${NB_PYTHON_PREFIX}/bin:${PATH}
# Set up shell to be bash
ENV SHELL=/bin/bash

# Set up user
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

EXPOSE 8888

# Allow target path repo is cloned to be configurable
ARG REPO_DIR=${HOME}
ENV REPO_DIR ${REPO_DIR}
WORKDIR ${REPO_DIR}

# Create group + user, and set proper permissions on home directory
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

# NOTE: build cache is not re-used here for some reason...
# Unfortunately, we have to chown the entire $CONDA_PREFIX to our user
# otherwise it is owned by root, and we can't install stuff into it. ;_;
# This increases the size of the image by a *lot*
RUN chown -R ${NB_USER}:${NB_USER} ${CONDA_DIR} \
    && chown -R ${NB_USER}:${NB_USER} ${HOME}
# If scripts required during build are present, copy them
COPY . ${REPO_DIR}
# NOTE: might need to ensure auxilary files are executable
#RUN chmod +x postBuild \
#     && chmod +x postBuild

# Apt.txt TODO

# RUN this section as NB_USER
# -----

# Conda environment
USER ${NB_USER}
RUN conda env create -f environment.yml \
    && conda clean -afy

#COPY --chown=${NB_UID} src/ ${REPO_DIR}
# ERROR: COPY failed: stat /var/lib/docker/tmp/docker-builder947064228/src: no such file or directory

# Not sure how activating non-base conda environment works!
#RUN ./activate_conda.sh
# NOTE: for now, this is required to run postBuild and adding conda activate to start
ENV PATH ${CONDA_DIR}/envs/notebook/bin:$PATH
# PostBuild
RUN ./postBuild

# Add start script if present
# Error: /usr/local/bin/repo2docker-entrypoint: line 6: exec: start: not foun
#ENV R2D_ENTRYPOINT start

# Add entrypoint
COPY repo2docker-entrypoint /usr/local/bin/repo2docker-entrypoint
ENTRYPOINT ["/usr/local/bin/repo2docker-entrypoint"]
# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
