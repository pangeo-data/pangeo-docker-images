#!/bin/bash

# Usage: docker run -v $PWD:/tmp pangeodev/base-notebook:master /tmp/run_tests.sh base-notebook
echo "Testing docker image {$1}..."

#pip install pytest
conda install pytest -y

pytest -v /tmp/tests/test_all.py /tmp/tests/test_$1.py

#EOF
