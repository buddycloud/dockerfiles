#!/bin/bash
mkdir -p /var/lib/backup
rsync -a /var/lib/postgresql /var/lib/backup
rsync -a /var/lib/prosody /var/lib/backup
rsync -a /var/lib/buddycloud-media-server /var/lib/backup
