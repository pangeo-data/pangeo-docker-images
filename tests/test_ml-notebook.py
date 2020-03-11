import pytest
import importlib
import sys

packages = [
    # machine learning stuff
    'tensorflow', 'keras', 'torch'
    ]

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)
