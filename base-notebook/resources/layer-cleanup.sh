#!/bin/bash
# Copyright 2020 CS GROUP - France, http://www.c-s.fr
# All rights reserved

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
