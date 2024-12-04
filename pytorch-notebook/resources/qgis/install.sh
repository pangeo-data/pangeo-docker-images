#!/bin/bash

# Libs
# Fix qgis build error
apt update && apt install -y gnupg software-properties-common
wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg
apt update
apt install -y qgis qgis-plugin-grass


# TO BE added to an export file
# ENV GDAL_CACHEMAX=128
# ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
# ENV C_INCLUDE_PATH=/usr/include/gdal
# ENV GDAL_NUM_THREADS=$OMP_NUM_THREADS
