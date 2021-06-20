#!/bin/sh
/usr/sbin/xinetd -dontfork &
/usr/local/bin/gotty \
  -p 8080 \
  --title-format "\"jnethack\""  \
  -w /opt/nethack/nethack.alt.org/dgamelaunch-wrapper 
