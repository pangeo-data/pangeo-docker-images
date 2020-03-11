import pytest
import importlib
import os.path
import sys

def test_config_paths():
    assert os.path.exists('/etc/profile.d/init_conda.sh')
    assert os.path.exists('/srv/conda/.condarc')
    assert os.path.exists('/srv/start')
    assert os.path.exists('/srv/conda/etc/dask.yml')

def test_import_metapackage():
    importlib.import_module('pangeo-notebook')

def test_conda_environment():
    assert sys.prefix == '/srv/conda/envs/pangeo'

def test_dask_config():
    import dask

    assert '/srv/conda/envs/pangeo/etc/dask' in dask.config.paths
    assert dask.config.config['labextension']['factory']['class'] == 'KubeCluster'
    assert 'worker-template' in dask.config.config['kubernetes']

# @pytest.fixture(scope='module')
# def client():
#     from dask.distributed import Client
#     with Client(n_workers=4) as dask_client:
#         yield dask_client
#
#
# def test_check_dask_version(client):
#     print(client)
#     versions = client.get_versions(check=True)
#v["name"] for v in self.scheduler_info["workers"].values()
#KeyError: 'workers'
