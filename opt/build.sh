#!/bin/bash
mkdir /opt/releases

cd /tmux

export OUTPUT="/opt/releases/tmux-$RELEASE_TAG-x86_64.AppImage"

/usr/bin/linuxdeploy --appdir=AppDir \
  -i /opt/tmux-logo-square.png \
  -d /opt/tmux.desktop \
  -e MakeBuild/bin/tmux \
  --custom-apprun=/opt/AppRun \
  --output=appimage
