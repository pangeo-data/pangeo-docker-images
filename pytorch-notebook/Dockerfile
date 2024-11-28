# ONBUILD instructions in base-image/Dockerfile are used to
# perform certain actions based on the presence of specific
# files (such as conda-linux-64.lock, start) in this repo.
# Refer to the base-image/Dockerfile for documentation.
ARG PANGEO_BASE_IMAGE_TAG=master
FROM cnes/base-image:${PANGEO_BASE_IMAGE_TAG}

# Required for nvidia drivers to work inside the image on GKE
# No-ops on other platforms - Azure doesn't need these set.
# Shouldn't negatively affect anyone, and makes life easier on GKE.
ENV PATH=${PATH}:/usr/local/nvidia/bin
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/nvidia/lib64
