#!/bin/bash
# Copyright 2024 CS GROUP - https://www.csgroup.eu
# Copyright 2024 CNES - https://cnes.fr
# All rights reserved
# This file is provided under MIT license. See LICENSE file.
set -e

# Libs
# Fix qgis build error
apt update && apt install -y gnupg software-properties-common
wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg
apt update
apt install -y qgis qgis-plugin-grass