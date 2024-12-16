#!/bin/bash
set -e

# noVNC setup
# See also:
# * https://github.com/manics/jupyter-omeroanalysis-desktop
# * https://github.com/ml-tooling/ml-workspace

# COPY /resources/vnc /opt
mv resources/vnc/start-notebook-genvnctoken.sh /usr/local/bin/
chmod +x /usr/local/bin/start-notebook-genvnctoken.sh
cp resources/vnc/* /opt

# Customize Desktop
mkdir -p /opt/vre/


add-apt-repository ppa:mozillateam/ppa --yes
apt-get update --quiet
DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
    dconf-cli \
    dbus-x11 \
    evince \
    file-roller \
    firefox-esr \
    geeqie \
    thunar-archive-plugin \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xorg \
    xubuntu-icon-theme

curl -sSfL https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar -zxf - -C /opt
mv /opt/noVNC-1.4.0 /opt/noVNC
# Fix VNC client
chmod o+r /opt/vnc.html
chmod o+r /opt/ui.js
mv /opt/vnc.html /opt/noVNC
mv /opt/ui.js /opt/noVNC/app
wget 'https://sourceforge.net/projects/turbovnc/files/3.1/turbovnc_3.1_amd64.deb/download' -O turbovnc_3.1_amd64.deb
apt-get install -y -q ./turbovnc_3.1_amd64.deb
rm ./turbovnc_3.1_amd64.deb
ln -s /opt/TurboVNC/bin/* /usr/local/bin/
mamba install --quiet websockify
cp resources/branding/desktop/wallpaper.png /opt/vre/wallpaper.png
cp -r resources/branding/desktop/xfce-perchannel-xml /etc/xdg/xfce4/xfconf/
# Fix missing rebind.so issue
cd /opt && git clone --quiet https://github.com/novnc/websockify.git
cd /opt/websockify && make && cp rebind.so /usr/local/bin
# Remove mail and logout desktop icons
rm /usr/share/applications/xfce4-session-logout.desktop
apt purge --quiet --yes xfce4-screensaver
# Remove lite client as the full client is the one being used in the Desktop Launcher
rm /opt/noVNC/vnc_lite.html
# Avoid creation of default folders
sed -i 's/^#*/#/' /etc/xdg/user-dirs.defaults
sed -i 's/enabled=True/enabled=False/' /etc/xdg/user-dirs.conf

chmod 664 /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/*
