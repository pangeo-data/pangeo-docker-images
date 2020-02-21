import pytest


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

    assert '/srv/conda/envs/notebook/etc/dask' in dask.config.paths
    assert dask.config.config['labextension']['factory']['class'] == 'KubeCluster'
    assert 'worker-template' in dask.config.config['kubernetes']
