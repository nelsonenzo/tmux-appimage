FROM ubuntu:16.04 as builder
## docker build . -t tmux --build-arg TMUX_RELEASE_TAG=3.2a
RUN apt-get update && apt-get install -y \
            pkg-config automake autoconf libtool libssl-dev bison byacc \
            curl imagemagick git vim

## linuxdeploy appimage must use --appimage-extract within a docker container.
RUN curl -OL https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage \
    && chmod +x linuxdeploy-x86_64.AppImage \
    && ./linuxdeploy-x86_64.AppImage --appimage-extract \
    && ln -nfs /squashfs-root/usr/bin/linuxdeploy /usr/bin/linuxdeploy


ENV BUILD_DIR=/opt/build
RUN mkdir -p $BUILD_DIR/AppDir/usr

# libevent
WORKDIR $BUILD_DIR
RUN git clone https://github.com/libevent/libevent --depth 1 -b release-2.1.12-stable && \
    cd libevent && \
    sh autogen.sh && \ 
    ./configure --prefix="$BUILD_DIR/AppDir/usr" --enable-shared && \
    make -j4 && \
    make install

## ncurses
WORKDIR $BUILD_DIR
RUN curl -OL https://invisible-island.net/datafiles/release/ncurses.tar.gz && \
    tar -xf ncurses.tar.gz && \
    NCURSES_DIR="$PWD/ncurses-6.3" && \
    cd "$NCURSES_DIR" && \
    ./configure --with-shared --prefix="$BUILD_DIR/AppDir/usr" --without-normal --without-debug && \
    make -j4 && \
    make install

FROM builder as appimage
ARG TMUX_RELEASE_TAG='master'
## Fetch Tmux Code
WORKDIR /opt
RUN git clone -b $TMUX_RELEASE_TAG --depth 1 https://github.com/tmux/tmux.git
ENV REPO_ROOT=/opt/tmux

## Build Tmux itself
WORKDIR $REPO_ROOT
ENV LD_LIBRARY_PATH="$BUILD_DIR/AppDir/usr/lib"
RUN sh autogen.sh
ENV CPPFLAGS="-I$BUILD_DIR/AppDir/usr/include -I$BUILD_DIR/AppDir/usr/include/ncurses"
ENV LDFLAGS="-L$BUILD_DIR/AppDir/usr/lib"
ENV PKG_CONFIG_PATH=$BUILD_DIR/AppDir/usr/lib/pkgconfig
RUN ./configure --prefix="$BUILD_DIR/AppDir/usr"
RUN make -j4 && make install

## Create Appimage
ADD AppRun $BUILD_DIR/AppDir/AppRun
RUN chmod 755 $BUILD_DIR/AppDir/AppRun
ADD tmux.desktop $BUILD_DIR/AppDir/tmux.desktop
RUN convert "$REPO_ROOT/logo/favicon.ico" "$REPO_ROOT/logo/favicon.png" && \
    cp "$REPO_ROOT/logo/favicon-1.png" "$BUILD_DIR/AppDir/favicon.png"

WORKDIR $BUILD_DIR
RUN OUTPUT="tmux.appimage" /usr/bin/linuxdeploy --appdir ./AppDir --output appimage \
    --icon-file "$REPO_ROOT/logo/favicon.ico" \
    --executable "$BUILD_DIR/AppDir/usr/bin/tmux"