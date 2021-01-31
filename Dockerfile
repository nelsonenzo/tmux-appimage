## Author: Nelson E Hernandez
FROM centos:centos7
## install build tools
RUN /usr/bin/yum -y update && /usr/bin/yum groupinstall -y "Development Tools" && yum clean all
RUN /usr/bin/yum install -y wget && yum install -y epel-release && yum install -y jq

RUN wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage \
    && chmod +x linuxdeploy-x86_64.AppImage \
    && ./linuxdeploy-x86_64.AppImage --appimage-extract \
    && ln -nfs /squashfs-root/usr/bin/linuxdeploy /usr/bin/linuxdeploy

## install tmux specific packages
RUN wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libevent-devel-2.0.21-4.el7.x86_64.rpm
RUN yum install -y libevent-devel-2.0.21-4.el7.x86_64.rpm
RUN yum install -y ncurses-devel

## Change RELEASE_TAG to desired version/git sha
ENV RELEASE_TAG=3.1c
RUN git clone -b $RELEASE_TAG --depth 1 https://github.com/tmux/tmux.git

WORKDIR /tmux

RUN sh autogen.sh && \
    ./configure --prefix=/tmux/MakeBuild && \
    make install

## complete the appimage build.
COPY ./opt /opt
RUN /opt/build.sh

## Produces artifact
## /opt/releases/tmux-3.0c-x86_64.AppImage

CMD /opt/build.sh
