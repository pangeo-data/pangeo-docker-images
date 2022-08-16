import pytest
import importlib
import sys
import os

packages = [
    # machine learning stuff
    'tensorflow', 'skimage', 'sklearn',
    'jax',
    # cupy import fails unless on GPU-enabled node:
    #'cupy', #libcuda.so.1: cannot open shared object file: No such file or directory
    # Error w/conda solve of pytorch+tensorflow, so not currently installed
    # 'torch'
    ]

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)

def test_start():
    print(os.environ)
    if os.environ.get('PANGEO_ENV') is not None:
        assert os.environ['PANGEO_ENV'] == 'ml-notebook'
