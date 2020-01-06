## Author: Nelson E Hernandez
## Date:
FROM debian:latest
## install build tools
RUN apt-get update && apt-get install -y autotools-dev automake git build-essential wget fuse file

RUN wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage && \
    chmod +x linuxdeploy-x86_64.AppImage && mv linuxdeploy-x86_64.AppImage /usr/bin/linuxdeploy

## install tmux specific packages
RUN apt-get install -y libevent-dev libncurses5-dev libncursesw5-dev bison byacc pkg-config

## Change RELEASE_TAG to desired version/git sha
ENV RELEASE_TAG=3.0a
RUN git clone https://github.com/tmux/tmux.git && cd tmux && git checkout $RELEASE_TAG

WORKDIR /tmux

RUN sh autogen.sh && \
    ./configure --prefix=/tmux/MakeBuild && \
    make install

CMD /opt/build.sh
