#!/bin/bash

function get_property
{
    PROP_FILE=$1
    PROP_KEY=$2
    PROP_VALUE=`cat $PROP_FILE | grep "$PROP_KEY" | cut -d'=' -f2`

    echo $PROP_VALUE
}

MEDIA_SERVER_PROPERTIES=/usr/share/buddycloud-media-server/mediaserver.properties
MEDIA_CLIENT_USERNAME=$(get_property $MEDIA_SERVER_PROPERTIES xmpp.connection.username)
MEDIA_CLIENT_DOMAIN=$(get_property $MEDIA_SERVER_PROPERTIES xmpp.connection.servicename)
MEDIA_CLIENT_PASSWORD=$(get_property $MEDIA_SERVER_PROPERTIES xmpp.connection.password)

prosodyctl register $MEDIA_CLIENT_USERNAME $MEDIA_CLIENT_DOMAIN $MEDIA_CLIENT_PASSWORD