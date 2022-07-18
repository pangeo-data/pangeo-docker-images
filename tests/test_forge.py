import pytest
import importlib
import os

packages = ['pangeo_forge_recipes']

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)

def test_boot_exists():
    assert os.path.exists('/usr/local/bin/boot')
