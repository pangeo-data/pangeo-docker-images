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


def setup_novnc():
    def _novnc_command(port):

        vnc_command = " ".join(shlex.quote(p) for p in ([
            "vncserver",
            "-rfbport", str(port),
            "-verbose",
            "-xstartup", "/usr/bin/dbus-launch xfce4-session",
            "-geometry", "1680x1050",
            "-fg"
        ]))

        return [
            "websockify", "-v",
            "--web", "/opt/noVNC",
            "--heartbeat", "30",
            str(port),
            "--",
            "/bin/sh", "-c", f"{vnc_command}"
        ]
    
    novnc_token = os.getenv("NOVNC_TOKEN")
    if not novnc_token:
        raise TypeError("NOVNC_TOKEN not set")
    
    return {
        "command": _novnc_command,
        "timeout": 20,
        "launcher_entry": {
            "title": "Desktop",
            "icon_path": os.path.join(
                os.path.dirname(os.path.abspath(__file__)), "icons", "xfce.svg"
            ),
            "path_info": "desktop/vnc.html?autoconnect=true&password=" + novnc_token 
        },
        "mappath": {"/": "/vnc.html"},
        "new_browser_tab": True,
    }
