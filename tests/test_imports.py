import importlib
import sys
from distutils.version import LooseVersion
import pytest

packages = [
    # these are things we can't live without, just to be safe
    'dask', 'distributed', 'dask_gateway',
    # jupyterhub and related utilities
    'jupyterhub', 'nbgitpuller'
    ]


@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)


# for current repo2docker config
def test_conda_environment():
    assert sys.prefix == '/srv/conda/envs/notebook'


# would be better to automatically get these from environment.yml
def test_pinned_versions():
    import tornado
    import dask_kubernetes
    import dask_labextension

    assert LooseVersion(tornado.version) >= LooseVersion('6.0.0')
    assert LooseVersion(dask_kubernetes.__version__) >= LooseVersion('0.9.0')
    assert LooseVersion(dask_labextension.__version__) >= LooseVersion('1.0.0')
