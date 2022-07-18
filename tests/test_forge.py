import pytest
import importlib
import os
import subprocess

packages = ['pangeo_forge_recipes']

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)

def test_boot_exists():
    subprocess.check_call(['find', '/usr/local'])
    subprocess.check_call(['pip', 'list'])
    assert os.path.exists('/usr/local/bin/boot')
