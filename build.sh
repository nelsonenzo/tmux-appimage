#!/bin/sh

export TMUX_RELEASE_TAG="master"
docker build . -t tmux --build-arg TMUX_RELEASE_TAG=$TMUX_RELEASE_TAG

docker rm -f tmuxcontainer
docker create -ti --name tmuxcontainer tmux bash
docker cp tmuxcontainer:/opt/build/tmux.appimage .
docker rm -f tmuxcontainer

# zsyncmake -z tmux.appimage
