#!/bin/bash

# Usage: ./update_lockfile.sh base-notebook
# NOTE: make sure condalock environment active:
# conda env create -f environment-condalock.yml
# conda activate condalock

conda-lock -f $1/environment.yml -p linux-64
mv conda-linux-64.lock $1/packages.txt
