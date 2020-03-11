import pytest
import importlib
import os.path


def test_config_paths():
    assert os.path.exists('/etc/profile.d/init_conda.sh')
    assert os.path.exists('/srv/conda/.condarc')
    assert os.path.exists('/srv/start')
    assert os.path.exists('/srv/conda/etc/dask.yml')
