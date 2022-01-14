#!/bin/sh

# Obtain and compile libncursesw6 so that we get 256 color support
BUILD_DIR=/opt/build

cd $BUILD_DIR
curl -OL https://invisible-island.net/datafiles/release/ncurses.tar.gz
tar -xf ncurses.tar.gz
NCURSES_DIR="$PWD/ncurses-6.3"
cd "$NCURSES_DIR"
./configure --with-shared --prefix="$BUILD_DIR/AppDir/usr" \
    --without-normal --without-debug
make -j4
make install
cd /opt/build