#!/bin/bash -l

# Usage: ./update_lockfile.sh base-notebook
# NOTE: make sure condalock environment active:
# conda env create -f environment-condalock.yml
# conda activate condalock
conda activate condalock
conda-lock -f $1/environment.yml -p linux-64
echo "Fully reproducible Conda lock file created in $1"
# EOF
