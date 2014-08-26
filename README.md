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
docker run 
  -i 
  --dns 8.8.8.8 
  -v /srv/ssl:/srv/ssl 
  -v /srv/buddycloud-stack/logs:/var/log/buddycloud 
  -v /srv/buddycloud-stack/media-storage:/var/lib/media-storage
  -P -p 80:80 -p 443:443 -p 5269:5269 
  -t buddycloud-stack
```

## Build speed

Squid will speed up builds

```bash
apt-get install squid
```

edit `/etc/squid3/squid.conf`

The important lines are
```
http_port 127.0.0.1:3128
refresh_pattern (\.deb|\.udeb|\.rpm)$   129600 100% 129600
```

```bash
service squid3 restart 
```

edit your docker config (`/etc/default/docker`)

```
# If you need Docker to use an HTTP proxy, it can also be specified here.
export http_proxy="http://127.0.0.1:3128/"
```

and restart with `service docker restart`
