# Tmux AppImage

### What is this?
Dockerfile to create an AppImage of tmux.

### Why use Docker?
The advantages to doing it this way are:
- Obtain consistent build results on any computer.
- No need to install a slew of build packages on your own machine.
- You can trust the tmux developers code, not some rando's AppImage distribution on the interwebz :p

### How do build it?
```
## clone me
git clone https://github.com/nelsonenzo/tmux-appimage.git

## change directory
cd tmux-appimage

## compile tmux from source by building container
export TMUX_RELEASE_TAG=3.2a

docker build . -t tmux --build-arg TMUX_RELEASE_TAG=$TMUX_RELEASE_TAG 

## extract the appimage file
docker create -ti --name tmuxcontainer tmux bash
docker cp tmuxcontainer:/opt/build/tmux.appimage .
docker rm -f tmuxcontainer
```


## To use AppImage
move appimage to executable location in your $PATH
```
mv tmux.appimage /usr/local/bin/tmux

tmux
```

### Where has the AppImage been tested to turn?
It has been tested on these fine Linux platforms and will likely work for anything newer than centos 6.9 (which is a few years old now.) Please file an issue if you find otherwise or need support on a different platform.
```
ubuntu 18
manjaro 19.02 Arch_x64
centos 6.9
centos 7.6
fedora 31
```

### What is the sauce that makes this work?
The [Dockerfile](Dockerfile) contains all the magic ingredients to compile tmux.

Huge thank you to https://github.com/michaellee8, whom taught me a lot about appimage builds with his code contributions.
