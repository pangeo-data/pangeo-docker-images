#!/bin/bash -l

# ==== ONLY EDIT WITHIN THIS BLOCK =====

export PANGEO_ENV="pangeo-notebook"
if ! [[ -z "${PANGEO_SCRATCH_PREFIX}" ]] && ! [[ -z "${JUPYTERHUB_USER}" ]]; then
    export PANGEO_SCRATCH="${PANGEO_SCRATCH_PREFIX}/${JUPYTERHUB_USER}/"
fi

# ==== ONLY EDIT WITHIN THIS BLOCK =====

exec "$@"
