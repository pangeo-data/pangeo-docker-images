#!/bin/bash

cp -r resources/nbproxy /opt/jupyter_proxy

chmod -R +rX /opt/jupyter_proxy
wget -q https://upload.wikimedia.org/wikipedia/commons/5/5b/Xfce_logo.svg -O /opt/jupyter_proxy/jupyter_proxy/icons/xfce.svg
chmod 664 /opt/jupyter_proxy/jupyter_proxy/icons/xfce.svg
pip install --upgrade /opt/jupyter_proxy
# rm -rf /opt/jupyter_proxy
