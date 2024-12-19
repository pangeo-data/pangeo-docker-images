#!/bin/bash
# Copyright 2024 CS GROUP - https://www.csgroup.eu
# Copyright 2024 CNES - https://cnes.fr
# All rights reserved
# This file is provided under MIT license. See LICENSE file.

set -e

# AWS cli
cd /opt 
curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
unzip -q awscliv2.zip 
./aws/install 
rm -rf /opt/aws /opt/awscliv2.zip 
pip install --quiet awscli-plugin-endpoint 
