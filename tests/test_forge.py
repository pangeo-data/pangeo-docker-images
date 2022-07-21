import pytest
import importlib
import os
import re
import subprocess

packages = ['pangeo_forge_recipes']

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)

def test_boot_exists():
    """
    Test the 'boot' executable used by apache beam exists
    """
    assert os.path.exists('/opt/apache/beam/boot')


def test_start_script():
    """
    Test that the start script dispatches invocations correctly.
    """
    # Under normal circumstances, start should just execute whatever we are passed
    # This is like having no entrypoint set
    assert subprocess.run([
        '/srv/start', 'echo', '-n', 'hello'
    ], capture_output=True).stdout.decode() == 'hello'

    # Copied from ./forge/start
    boot_args = [
        '-id', '-control_endpoint', '-logging_endpoint',
        'artifact_endpoint', 'provision_endpoint'
    ]
    # If the parameters that Apache beam passes to the boot program are
    # detected, it should instead call the apache beam boot program! This is
    # equivalent to the apache beam boot program being set as entrypoint, which
    # is what the apache beam documentation tells us to do. The exact parameter
    # boot complains about seems to be non deterministic, so let's use a bit of
    # a fuzzy regex to check this works.
    assert re.search(
        r'No(.*)provided.\n$',
        subprocess.run(['/srv/start'] + boot_args, capture_output=True).stderr.decode()
    )