#!/bin/bash

# Usage: docker run -v $PWD:/home/jovyan pangeodev/base-notebook:master ./run_tests.sh base-notebook
echo "Testing docker image {$1}..."

pip install pytest

pytest -v tests/test_base-image.py tests/test_$1.py

#EOF
