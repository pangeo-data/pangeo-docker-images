import pytest
import importlib
import os
import re
import subprocess

packages = ['pangeo_forge_recipes', 'apache_beam']

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)


def test_gcp_auth_available():
    """
    Make sure apache-beam knows it has gcp support
    """
    # https://github.com/apache/beam/blob/0760f13c4a5ca1dcfa0e2fad7d875e2d2f050963/sdks/python/apache_beam/internal/gcp/auth.py#L29
    import apache_beam.internal.gcp.auth as auth
    assert auth._GOOGLE_AUTH_AVAILABLE

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
        '-artifact_endpoint', '-provision_endpoint'
    ]
    # If the parameters that Apache beam passes to the boot program are
    # detected, it should instead call the apache beam boot program! This is
    # equivalent to the apache beam boot program being set as entrypoint, which
    # is what the apache beam documentation tells us to do. The exact parameter
    # boot complains about seems to be non deterministic, so let's use a bit of
    # a fuzzy regex to check this works.
    assert re.search(
        r'flag needs an argument:',
        subprocess.run(['/srv/start'] + boot_args, capture_output=True).stderr.decode()
    )