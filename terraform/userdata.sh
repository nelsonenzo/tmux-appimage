#!/bin/bash

DOWNLOAD=$(curl -s "https://api.github.com/repos/nelsonenzo/tmux-appimage/releases/tags/master" | grep browser_download_url | awk '{print $2}')
DOWNLOAD=$(sed -e 's/^"//' -e 's/"$//' <<<"$DOWNLOAD")
curl -L -s $DOWNLOAD --output /usr/local/bin/tmux
sudo chmod +x /usr/local/bin/tmux

function touch-test {
  sleep 1;
  if grep -q 'touch: missing file operand' $HOME/touch-output.txt; then
    echo 1 > $HOME/touch-passed-true
  fi
}

function validate_tmux_session_running {
  tmux ls;
  if [ $? = 0 ]; then
    echo 1 > $HOME/session-passed-true
  else
    exit 1;
  fi
}

if which pacman; then
  sudo pacman -Sy --noconfirm fuse2
  TERM=xterm tmux new -d -s touch-session 'touch > $HOME/touch-output.txt 2>&1;'
  touch-test
  TERM=xterm tmux -2 tmux new -d -s test-session
elif which yum; then
  sudo yum install -y fuse
  TERM=xterm tmux new -d -s touch-session 'touch > $HOME/touch-output.txt 2>&1;'
  touch-test
  TERM=xterm tmux -2 tmux new -d -s test-session
elif which zypper; then
  sudo zypper install -y fuse
  tmux new -d -s touch-session 'touch > $HOME/touch-output.txt 2>&1;'
  touch-test
  tmux new -d -s test-session
elif which apt-get; then
  sudo apt-get install -y fuse
  tmux new -d -s touch-session 'touch > $HOME/touch-output.txt 2>&1;'
  touch-test
  tmux new -d -s test-session
else
  echo "no-package-manager" > tmux-env.txt
fi

validate_tmux_session_running
