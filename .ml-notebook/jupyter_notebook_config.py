import os

# Configure nb_conda_kernels to avoid registering jupyter kernels in our conda
# environment again.
c.CondaKernelSpecManager.env_filter = f'.*envs/{os.environ["CONDA_ENV"]}.*'
