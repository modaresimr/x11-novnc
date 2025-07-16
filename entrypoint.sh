#!/bin/bash
set -ex

RUN_FLUXBOX=${RUN_FLUXBOX:-yes}
RUN_XTERM=${RUN_XTERM:-yes}

# Setup VNC password
mkdir -p ~/.vnc


if [[ -n "$VNC_PASSWORD" ]]; then
  x11vnc -storepasswd "$VNC_PASSWORD" ~/.vnc/passwd
  chmod 600 ~/.vnc/passwd
fi


if [[ "$VNC_PASSWORD_VIEWONLY" == "" ]]; then
  echo "">~/.vnc/viewonly.pass
  chmod 600 ~/.vnc/viewonly.pass
else
  x11vnc -storepasswd "$VNC_PASSWORD_VIEWONLY" ~/.vnc/viewonly.pass
  chmod 600 ~/.vnc/viewonly.pass
fi




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
