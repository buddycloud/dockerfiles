Buddycloud ♥ Docker
===================

A dockerfile to run the Buddycloud stack. 
Please submit more.

Includes
* webclient
* API + xmpp-ftw
* buddycloud-server
* media server
* prosody server

## Setup

* Install Docker on your system
* `git clone git@github.com:buddycloud/docker.git`
* `cd docker/buddycloud-stack`
* `sudo docker.io  build -t buddycloud-stack .`
* `sudo /usr/bin/docker.io run  -v <local-persistient-storage-area>:/var/lib/postgres  buddycloud-stack`
