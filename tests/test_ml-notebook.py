import pytest
import importlib
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

def test_jax_tf_together():
    """ sometimes this impport fails due to sharing private symbols
        complicated longer story, but it is better to
        ensure they can coexist
    """
    import tensorflow, jax
    assert int(tensorflow.__version__[0]) >= 2
    assert int(jax.__version__[0]) >= 0


def test_jax_random_number_generator():
    """
    Ensure that initializing a random number generator on JaX works.

    Regression test for checking that JaX and cuda-nvcc are installed and compatible on
    GPU devices, see https://github.com/pangeo-data/pangeo-docker-images/issues/438.
    """
    import jax
    import numpy as np
    from jax import random

    # Test running on CPU
    with jax.default_device(jax.devices("cpu")[0]):
        key = random.key(seed=42)
        x = random.normal(key=key)
        np.testing.assert_allclose(x, -0.18471177)

    # Test running on GPU
    with jax.default_device(jax.devices("gpu")[0]):
        key = random.key(seed=24)
        x = random.normal(key=key)
        np.testing.assert_allclose(x, -1.168644)
