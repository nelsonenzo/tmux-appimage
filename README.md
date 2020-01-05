# Tmux AppImage

### What is this?
Dockerfile to create an AppImage of tmux.

### Why use docker?
The advantages to doing it this way are:
- Obtain consistent build results on any computer.
- No need to install a slew of build packages on your own machine.
- You can trust the tmux developers code, not some rando's AppImage distribution on the interwebz :p

### How do build it?
```
## clone me
git clone https://github.com/nelsonenzo/tmux-appimage.git

## compile tmux
docker build . -t tmux

## make appimage
docker run -it --cap-add SYS_ADMIN --cap-add MKNOD --device /dev/fuse:mrw -v "$PWD"/opt:/opt tmux

## move appimage to executable location in your $PATH
mv ./opt/releases/tmux.*AppImage /usr/bin/tmux

tmux
```

### Will it only run on Debian?
I suspect the tmux binary is very portable and this build will work on multiple Linux variants, but I have only tested it on Debian based distros so far. When I have tested on other distros I will remove this message.

### What is the sauce that makes this work?
The [Dockerfile](Dockerfile) contains all the magic ingredients to compile tmux.

[opt/build.sh](opt/build.sh) creates the AppImage.
