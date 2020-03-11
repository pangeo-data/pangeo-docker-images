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


def test_conda_environment():
    assert sys.prefix == '/srv/conda/envs/pangeo'


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

def test_dask_config():
    import dask

    assert '/srv/conda/envs/pangeo/etc/dask' in dask.config.paths
    assert dask.config.config['labextension']['factory']['class'] == 'KubeCluster'
    assert 'worker-template' in dask.config.config['kubernetes']
