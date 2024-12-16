#!/bin/bash

# Usage: docker run -w /srv/test -v $PWD:/srv/test pangeodev/base-notebook:latest ./run_tests.sh base-notebook
echo "Testing docker image {$1}..."

# Install pytest on top of existing environment
python -m pip install pytest

pytest -v tests/test_all.py tests/test_$1.py

#EOF
