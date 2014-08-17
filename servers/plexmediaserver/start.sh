#! /bin/sh

set -e
set -x
rm -f "/data/Library/Application Support/Plex Media Server/plexmediaserver.pid"

service dbus start
service avahi-daemon start

HOME=/data start_pms
