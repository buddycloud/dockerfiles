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

## How this works

This Dockerfile setups a buddycloud stack with the following features:
* `config` directory contains a copy of all config files that are needed for a full stack.
* `-v somewhere-on-your-host-fs:/var/log/`

## Setup

* Install Docker on your system
* `git clone git@github.com:buddycloud/docker.git`
* `cd docker/buddycloud-stack`
* quickly configure the stack for your own domain using `find ./config -type f -exec sed -i -e 's/EXAMPLE.COM/mydomain.com/g' {} \;`
* `sudo docker.io  build -t buddycloud-stack .`
* ```sudo /usr/bin/docker.io run  \ 
  -v somewhere-on-your-host-fs:/var/log/ 
  -v <local-persistient-storage-area>:/var/lib/postgres  \ 
  buddycloud-stack```
