# Copyright 2024 CS GROUP - https://www.csgroup.eu
# All rights reserved
# This file is provided under MIT license. See LICENSE file.

"""
Return config on servers

See https://jupyter-server-proxy.readthedocs.io/en/latest/server-process.html
for more information.
"""
import getpass
import os
import shutil
import shlex
import subprocess


def setup_codeserver():
    # Make sure codeserver is in $PATH
    def _codeserver_command(port):
        full_path = shutil.which("code-server")
        if not full_path:
            raise FileNotFoundError("Can not find code-server in $PATH")
        working_dir = os.getenv("CODE_WORKINGDIR", None)
        if working_dir is None:
            working_dir = os.path.expanduser("~")
        if working_dir is None:
            working_dir = os.getenv("JUPYTER_SERVER_ROOT", ".")

        return [
            full_path,
            "--port=" + str(port),
            "--auth",
            "password",
            "--disable-telemetry",
            "--extensions-dir",
            os.path.join(os.path.join(working_dir, ".vscode"), "extensions"),
            working_dir,
        ]

    return {
        "command": _codeserver_command,
        "timeout": 20,
        "launcher_entry": {
            "title": "VS Code IDE",
            "icon_path": os.path.join(
                os.path.dirname(os.path.abspath(__file__)), "icons", "vscode.svg"
            ),
        },
        "new_browser_tab": True,
    }
