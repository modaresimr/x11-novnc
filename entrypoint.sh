#!/bin/bash
set -ex

RUN_FLUXBOX=${RUN_FLUXBOX:-yes}
RUN_XTERM=${RUN_XTERM:-yes}

# Setup VNC password
mkdir -p ~/.vnc

# Set read-write password
if [[ -n "$VNC_PASSWORD" ]]; then
  x11vnc -storepasswd "$VNC_PASSWORD" ~/.vnc/passwd
fi


if [[ "$VNC_PASSWORD_VIEWONLY" == "" ]]; then
  echo "" | x11vnc -storepasswd - ~/.vnc/viewonly.pass || true
else
  x11vnc -storepasswd "$VNC_PASSWORD_VIEWONLY" ~/.vnc/viewonly.pass
fi

# Merge passwords (x11vnc expects both in a single file)
if [[ -f ~/.vnc/passwd && -f ~/.vnc/viewonly.pass ]]; then
  cat ~/.vnc/viewonly.pass >> ~/.vnc/passwd
fi

chmod 600 ~/.vnc/passwd
rm -f ~/.vnc/viewonly.pass

case $RUN_FLUXBOX in
  false|no|n|0)
    rm -f /app/conf.d/fluxbox.conf
    ;;
esac

case $RUN_XTERM in
  false|no|n|0)
    rm -f /app/conf.d/xterm.conf
    ;;
esac

exec supervisord -c /app/supervisord.conf
