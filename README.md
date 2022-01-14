# Tmux AppImage
One-liner to get the latest tmux.appimage build:
```
curl -s https://api.github.com/repos/nelsonenzo/tmux-appimage/releases/latest \
| grep "browser_download_url.*appimage" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi - \
&& chmod +x tmux.appimage

## optionaly, move it into your $PATH
mv tmux.appimage /usr/local/bin/tmux
tmux
```
### What is this?
A Docker build of Tmux Appimage

### Why use Docker?
The advantages of using docker:
- Obtain consistent build results on any computer.
- No need to install a slew of build packages on your own machine.
- You can trust the tmux developers code, not some rando's AppImage distribution on the interwebz :p

### Build it yourself from source code
I assume you have docker installed already.
```
#### clone me & change directory
git clone https://github.com/nelsonenzo/tmux-appimage.git
cd tmux-appimage

#### Set the desired tmux release tag and build
export TMUX_RELEASE_TAG=3.2a
docker build . -t tmux --build-arg TMUX_RELEASE_TAG=$TMUX_RELEASE_TAG 

#### extract the appimage file
docker create -ti --name tmuxcontainer tmux bash
docker cp tmuxcontainer:/opt/build/tmux.appimage .
docker rm -f tmuxcontainer

ls -al tmux.appimage
```

### Where has the AppImage been tested to turn?
It has been tested on these fine Linux platforms and will likely work for anything newer than centos 6.9 (which is a few years old now.) Please file an issue if you find otherwise or need support on a different platform.
```
ubuntu 18.04
ubuntu 16.04
manjaro 19.02
centos 7
centos 8
fedora 33
```
The distributed build will not work on older os's, since they have older glibc libraries.
If you need it to work on those systems, try modifying the Dockerfile to use an older ubuntu as the base image and building.
```
centos 6
```
### What is the sauce that makes this work?
The [Dockerfile](Dockerfile) contains all the magic ingredients to compile tmux.

Huge thank you to https://github.com/michaellee8, whom taught me a lot about appimage builds with his code contributions.
