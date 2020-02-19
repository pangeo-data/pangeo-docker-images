FROM pangeodev/base-image:latest

# RUN as NB_USER
# -----
# all other layers inherited from base-image:latest

# This should overwrite base-image /srv contents
WORKDIR ${APP_BASE}
COPY . ${APP_BASE}

# Update existing conda notebook environment
RUN conda env update -n notebook -f environment.yml --prune \
    && conda clean -afy \
    && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
    && find ${CONDA_DIR}/envs/notebook/lib/python*/site-packages/bokeh/server/static -follow -type f -name '*.js' ! -name '*.min.js' -delete

# Postbuild
RUN ./postBuild \
    && rm -rf ${HOME}/.cache ${HOME}/.npm ${HOME}/.yarn \
    && rm -rf ${KERNEL_PYTHON_PREFIX}/share/jupyter/lab/staging \
    && find ${KERNEL_PYTHON_PREFIX} -follow -type f -name '*.js.map' -delete

WORKDIR ${HOME}
