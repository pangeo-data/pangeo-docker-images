# Build a custom image

Advanced users may want a highly customized environment that still works on Pangeo BinderHubs. You can do that by building off the pangeo `base-image` following our [template repository example](https://github.com/pangeo-data/pangeo-binder-template). Further documentation on the configuration files in the `binder` subfolder can be found in the [repo2docker documentation](https://repo2docker.readthedocs.io/en/latest/config_files.html#configuration-files).

## Add packages to a notebook image

If you only need to add a small number of packages, you can build a thin image on top of an existing Pangeo notebook image such as `pangeo/pangeo-notebook` instead of starting from `base-image`.

Pangeo notebook images install user-facing Python packages into the `notebook` conda environment. The environment is also exposed as the `CONDA_ENV` environment variable, so Dockerfiles can target it without hard-coding the name.

```dockerfile
FROM pangeo/pangeo-notebook:latest

# Install conda packages into the existing notebook environment.
RUN mamba install --yes --name ${CONDA_ENV} \
    package_a \
    package_b \
    && mamba clean --all --force --yes

# Install pip packages into the same environment.
RUN /srv/conda/envs/${CONDA_ENV}/bin/python -m pip install --no-cache-dir package_c
```

For larger changes, keep package declarations in files and copy them into the image:

```dockerfile
FROM pangeo/pangeo-notebook:latest

COPY environment.yml /tmp/environment.yml
COPY requirements.txt /tmp/requirements.txt

RUN mamba env update --name ${CONDA_ENV} --file /tmp/environment.yml \
    && mamba clean --all --force --yes
RUN /srv/conda/envs/${CONDA_ENV}/bin/python -m pip install --no-cache-dir -r /tmp/requirements.txt
```

When possible, prefer conda-forge packages installed with `mamba` and use `pip` only for packages that are not available from conda-forge. Pin the parent Pangeo image tag and important package versions for reproducible images.
