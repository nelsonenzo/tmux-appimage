FROM ubuntu:18.04 as builder
RUN apt-get update && apt-get install -y \
            pkg-config automake autoconf libtool libssl-dev bison byacc \
            curl imagemagick git vim

## linuxdeploy appimage must use --appimage-extract within a docker container.
RUN curl -OL https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage \
    && chmod +x linuxdeploy-x86_64.AppImage \
    && ./linuxdeploy-x86_64.AppImage --appimage-extract \
    && ln -nfs /squashfs-root/usr/bin/linuxdeploy /usr/bin/linuxdeploy

WORKDIR /opt
ENV BUILD_DIR=/opt/build
ENV REPO_ROOT=/opt/tmux
RUN mkdir -p $BUILD_DIR
## Use --build-arg tmux_release_tag=3.2a to use a specific release version
ARG tmux_release_tag=master
ENV RELEASE_TAG=$tmux_release_tag
RUN git clone -b $RELEASE_TAG --depth 1 https://github.com/tmux/tmux.git
WORKDIR $REPO_ROOT

## Tmux dependencies libevent and ncurses.
ADD opt/pipeline /opt/pipeline
RUN /opt/pipeline/1_install_libevent.sh
RUN /opt/pipeline/2_install_ncurses.sh


FROM builder as appimage

## Tmux itself
WORKDIR /opt/tmux
ENV LD_LIBRARY_PATH="$BUILD_DIR/AppDir/usr/lib"
RUN sh autogen.sh
ENV CPPFLAGS="-I$BUILD_DIR/AppDir/usr/include -I$BUILD_DIR/AppDir/usr/include/ncurses"
ENV LDFLAGS="-L$BUILD_DIR/AppDir/usr/lib"
ENV PKG_CONFIG_PATH=$BUILD_DIR/AppDir/usr/lib/pkgconfig
RUN ./configure --prefix="$BUILD_DIR/AppDir/usr"
RUN make -j4 && make install

## Appimage
ADD opt/AppRun $BUILD_DIR/AppDir/AppRun
RUN chmod 755 $BUILD_DIR/AppDir/AppRun
ADD opt/tmux.desktop $BUILD_DIR/AppDir/tmux.desktop
RUN convert "$REPO_ROOT/logo/favicon.ico" "$REPO_ROOT/logo/favicon.png" && \
    cp "$REPO_ROOT/logo/favicon-1.png" "$BUILD_DIR/AppDir/favicon.png"

WORKDIR $BUILD_DIR
RUN OUTPUT="tmux.appimage" /usr/bin/linuxdeploy --appdir ./AppDir --output appimage \
    --icon-file "$REPO_ROOT/logo/favicon.ico" \
    --executable "$BUILD_DIR/AppDir/usr/bin/tmux"