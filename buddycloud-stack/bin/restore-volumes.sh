#!/bin/bash

function restore
{
    if [ ! "$(ls -A /var/lib/$1)" ]; then
    	rsync -a /var/lib/backup/$1 /var/lib
    fi
}

restore prosody
restore postgresql
restore buddycloud-media-server
