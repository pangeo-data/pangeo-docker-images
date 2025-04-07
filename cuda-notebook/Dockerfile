# Dockerfile for pangeo images with CUDA dependencies
FROM rapidsai/miniforge-cuda:cuda12.8.0-base-ubuntu24.04-py3.13

LABEL org.opencontainers.image.source=https://github.com/pangeo-data/pangeo-docker-images

ENV CONDA_ENV=notebook\
    NB_USER=jovyan\
    NB_UID=1000 \
    SHELL=/bin/bash \
    CONDA_DIR=/opt/conda
ENV NB_PYTHON_PREFIX=${CONDA_DIR}/envs/${CONDA_ENV}
ENV PATH=${NB_PYTHON_PREFIX}/bin:${CONDA_DIR}/bin:${PATH}

RUN echo "Creating ${NB_USER} user..." \
    # Change user name from ubuntu to jovyan
    && usermod --login ${NB_USER} ubuntu \
    # Change group name from ubuntu to jovyan
    && groupmod --new-name ${NB_USER} ubuntu \
    # Set home directory of jovyan user
    && usermod --home /home/${NB_USER} --move-home ${NB_USER} \
    # Make sure that /opt/conda is owned by non-root user, so we can install things there
    && chown -R ${NB_USER}:${NB_USER} ${CONDA_DIR}

USER ${NB_USER}
WORKDIR /home/${NB_USER}

RUN mamba env create --name ${CONDA_ENV} --yes \
    cuda-version=12.8 \
    jupyterhub-singleuser=5 \
    jupyterlab-nvdashboard

EXPOSE 8888
CMD ["jupyter", "lab", "--no-browser", "--ip", "0.0.0.0"]
