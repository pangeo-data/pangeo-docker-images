import pytest
import importlib
import sys

packages = [
    # machine learning stuff
    'tensorflow',
    # need to test on GPU-enabled node? 
    #'cupy', #libcuda.so.1: cannot open shared object file: No such file or directory
    # Error w/conda solve of pytorch
    # 'torch'
    ]

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)
