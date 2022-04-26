# ONBUILD instructions in base-image/Dockerfile are used to
# perform certain actions based on the presence of specific
# files (such as conda-linux-64.lock, start) in this repo.
# Refer to the base-image/Dockerfile for documentation.
FROM pangeo/base-image:master

# Required for nvidia drivers to work inside the image
ENV PATH=${PATH}:/usr/local/nvidia/bin
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/nvidia/lib64
