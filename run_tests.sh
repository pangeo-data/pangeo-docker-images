#!/bin/bash

# Usage: docker run -w /srv/test -v $PWD:/srv/test pangeodev/base-notebook:latest ./run_tests.sh base-notebook
echo "Testing docker image {$1}..."

# --no-channel-priority added b/c solver failing installing into ml-notebook
conda install pytest --freeze-installed --no-channel-priority

pytest -v tests/test_all.py tests/test_$1.py

#EOF
