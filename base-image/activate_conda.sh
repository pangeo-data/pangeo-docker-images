CONDA_PROFILE="${CONDA_DIR}/etc/profile.d/conda.sh"
test -f $CONDA_PROFILE && . $CONDA_PROFILE

conda activate ${NB_PYTHON_PREFIX}
