import pytest
import importlib
import sys
import os

packages = [
    # machine learning stuff
    "pytorch_lightning",
    "skimage",
    "sklearn",
    "torch",
    "torchgeo",
]


@pytest.mark.parametrize("package_name", packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)


def test_start():
    print(os.environ)
    if os.environ.get("PANGEO_ENV") is not None:
        assert os.environ["PANGEO_ENV"] == "pytorch-notebook"


def test_torch_uses_mkl():

    import torch

    blas_info_index = torch.__config__.show().find("BLAS_INFO")
    assert torch.__config__.show()[blas_info_index + 10 : blas_info_index + 13] == "mkl"
