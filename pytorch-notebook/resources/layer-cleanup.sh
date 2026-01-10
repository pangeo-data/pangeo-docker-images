#!/bin/bash
# Copyright 2024 CS GROUP - https://www.csgroup.eu
# All rights reserved
# This file is provided under MIT license. See LICENSE file.

apt-get autoclean --yes
apt-get autoremove --yes

rm -rf /var/lib/apt/lists/*
rm -rf /etc/apt/sources.list.d/*
rm -rf /usr/local/src/*

rm -rf /var/cache/apt/*
rm -rf /root/.cache/*
# including /root/.cache/pip
rm -rf /usr/local/share/.cache/*
# including /usr/local/share/.cache/yarn

if [ -x "$(command -v npm)" ]; then
    npm cache clean --force
    rm -rf /root/.npm/*
    rm -rf /root/.node-gyp/*
    rm -rf /usr/local/share/jupyter/lab/staging/node_modules/*
    rm -rf /opt/*/node_modules/*
fi

rm -rf /tmp/* /var/tmp/*

echo "Layer cleaned"

exit 0
