# Environment variables

The runtime environment sets two variables by default

1. `$PANGEO_ENV`: name of the conda environment.
2. `$PANGEO_SCRATCH`: a URL like `gcs://pangeo-scratch/username/` that
   points to a cloud storage bucket for temporary storage. This is set
   if the variable `$PANGEO_SCRATCH_PREFIX` and `JUPYTERHUB_USER`
   are detected. The prefix should be like `s3://pangeo-scratch`.
   This is not present in the `forge/` image.
