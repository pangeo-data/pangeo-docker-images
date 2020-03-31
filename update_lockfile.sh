#!/bin/bash -l
# Run in x-notebook directory
# Usage: ./update_lockfile.sh condarc.yml
conda activate condalock
CONDARC=$1 conda-lock -f environment.yml -p linux-64
echo "Fully reproducible Conda lock file created in $1"
# EOF
