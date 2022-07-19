import pytest
import importlib
import os
import subprocess

packages = ['pangeo_forge_recipes']

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)

def test_boot_exists():
    """
    Test the 'boot' executable used by apache beam exists
    """
    assert os.path.exists('/usr/local/bin/boot')

def test_boot_static():
    """
    Test the 'boot' executable used by apache beam is a static executable.

    It's built on a debian system but used in ubuntu. It is probably
    ok for it to be dynamically linked, but better safe here than sorry.
    """
    proc = subprocess.run(['ldd', '/usr/local/bin/boot'], capture_output=True)

    # `ldd` returns failure if the executable isn't dynamic, which ours isn't
    assert proc.returncode == 1

    # Check the output to make sure it's not a dynamic executable
    assert proc.stderr.decode().strip() == 'not a dynamic executable'


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
    # is what the apache beam documentation tells us to do
    assert subprocess.run(['/srv/start'] + boot_args, capture_output=True).stderr ==  \
    subprocess.run(['/usr/local/bin/boot'] + boot_args, capture_output=True).stderr