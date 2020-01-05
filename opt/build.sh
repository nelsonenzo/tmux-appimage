#!/bin/bash
mkdir /opt/releases
cd /tmux
sha=$(git rev-parse --short master)
export OUTPUT="/opt/releases/tmux-debian-$sha-x86_64.AppImage"
/usr/bin/linuxdeploy --appdir=AppDir -i /opt/tmux-logo-square.png -d /opt/tmux.desktop -e MakeBuild/bin/tmux --output=appimage
