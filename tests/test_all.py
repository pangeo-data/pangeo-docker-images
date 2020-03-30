import pytest
import importlib
import os.path
import sys

def test_config_paths():
    assert os.path.exists('/etc/profile.d/init_conda.sh')
    assert os.path.exists('/srv/conda/.condarc')
    assert os.path.exists('/srv/start')
    assert os.path.exists('/srv/conda/etc/dask.yml')

def test_default_conda_environment():
    assert sys.prefix == '/srv/conda/envs/notebook'

packages = [
    # included in pangeo-notebook metapackage
    # https://github.com/conda-forge/pangeo-notebook-feedstock/blob/master/recipe/meta.yaml
    'dask', 'distributed', 'dask_kubernetes', 'dask_gateway', 'dask_labextension',
    # jupyterhub and related utilities
    'jupyterhub', 'jupyterlab', 'nbgitpuller'
    ]

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)

# NOTE: will want to change these for dask-gateway
def test_dask_config():
    import dask
    assert '/srv/conda/etc' in dask.config.paths
    assert '/srv/conda/envs/notebook/etc/dask' in dask.config.paths
    assert dask.config.config['labextension']['factory']['class'] == 'KubeCluster'
    assert 'worker-template' in dask.config.config['kubernetes']

# Works locally but hanging on GitHub Actions, possibly due to:
# Unclosed client session client_session: <aiohttp.client.ClientSession object at 0x7ff7a2931950>
#@pytest.fixture(scope='module')
#def client():
#    from dask.distributed import Client
#    with Client(n_workers=4) as dask_client:
#        yield dask_client
#
#def test_check_dask_version(client):
#    print(client)
#    versions = client.get_versions(check=True)
