import pytest
import importlib
import sys
#from distutils.version import LooseVersion
# would be better to automatically get these from environment.yml
#def test_pinned_versions():
#    import tornado
#    import dask_kubernetes
#    import dask_labextension
#
#    assert LooseVersion(tornado.version) >= LooseVersion('6.0.0')
#    assert LooseVersion(dask_kubernetes.__version__) >= LooseVersion('0.9.0')
#    assert LooseVersion(dask_labextension.__version__) >= LooseVersion('1.0.0')

packages = [
    # these are things we can't live without, just to be safe
    'dask', 'distributed', 'dask_kubernetes',
    # jupyterhub and related utilities
    #'jupyterhub', 'nbgitpuller'
    ]


@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)


# for current repo2docker config
def test_conda_environment():
    assert sys.prefix == '/srv/conda/envs/pangeo'


@pytest.fixture(scope='module')
def client():
    from dask.distributed import Client
    with Client(n_workers=4) as dask_client:
        yield dask_client


def test_check_dask_version(client):
    print(client)
    versions = client.get_versions(check=True)


def test_dask_config():
    import dask

    assert '/srv/conda/envs/pangeo/etc/dask' in dask.config.paths
    assert dask.config.config['labextension']['factory']['class'] == 'KubeCluster'
    assert 'worker-template' in dask.config.config['kubernetes']
