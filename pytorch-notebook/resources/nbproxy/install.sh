#!/bin/bash
# Copyright 2024 CS GROUP - https://www.csgroup.eu
# Copyright 2024 CNES - https://cnes.fr
# All rights reserved
# This file is provided under MIT license. See LICENSE file.
set -e

cp -r resources/nbproxy /opt/jupyter_proxy

chmod -R +rX /opt/jupyter_proxy
pip install --upgrade /opt/jupyter_proxy
# rm -rf /opt/jupyter_proxy
