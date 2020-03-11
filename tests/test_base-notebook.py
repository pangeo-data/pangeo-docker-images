import pytest
import importlib
import sys

packages = [
    # these are things we can't live without, just to be safe
    'dask', 'distributed', 'dask_kubernetes',
    # jupyterhub and related utilities
    'jupyterhub', 'nbgitpuller'
    ]

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)
