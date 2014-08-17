## About

A quick Docker container to run the buddycloud stack.
* webclient
* API + xmpp-ftw
* buddycloud-server
* media server
* prosody server

## Setup

* Install docker on your system
* `git clone git@github.com:imaginator/dockerfiles.git`
* `cd dockerfiles/servers/buddycloud-stack`
* `sudo docker.io  build -t buddycloud-stack .`
* `sudo /usr/bin/docker.io run  -v <local-persistient-storage-area>:/var/lib/postgres  buddycloud-stack`
