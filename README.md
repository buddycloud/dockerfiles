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
* `git clone git@github.com:buddycloud/dockerfiles.git`
* `cd dockerfiles/buddycloud-stack`
* quickly configure the stack for your own domain using `find ./config -type f -exec sed -i -e 's/EXAMPLE.COM/mydomain.com/g' {} \;`
* `docker  build -t buddycloud-stack .`

## Running

Launch your process
```
docker run \
  -i \
  --dns 127.0.0.1 \
  -v /srv/buddycloud-stack/logs:/var/log/buddycloud \
  -v /srv/buddycloud-stack/prosody:/var/lib/prosody \
  -v /srv/buddycloud-stack/postgresql:/var/lib/postgresql \
  -v /srv/buddycloud-stack/buddycloud-media-server:/var/lib/buddycloud-media-server \
  -P -p 80:80 -p 443:443 -p 5269:5269 \
  -t buddycloud-stack
```

## Ways to run this

### A new domain (buddycloud.dev)

The existing Dockerfile will _just work_

The Dockerfile runs a nameserver that resolves the different buddycloud components. 

All you need to do is add `buddycloud.dev` resolve to `localhost`

```bash
echo "127.0.0.1 buddycloud.dev" >> /etc/hosts
```

### On am existing domain (your-domain.com)

Assuming you have an existing XMPP server you will need to...
