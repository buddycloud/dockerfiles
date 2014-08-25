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
  --dns 127.0.0.1 \
  -v /srv/buddycloud-stack/logs:/var/log/ \
  -v /srv/buddycloud-stack/postgres:/var/lib/postgres \
  -v /srv/buddycloud-stack/media-storage:/var/lib/media-storage \
  buddycloud-stack
```

## Tips

```bash
apt-get install squid
sudo vim /etc/squid3/squid.conf
http_port 127.0.0.1:3128
service squid3 restart 
```

edit your docker config (`/etc/default/docker`)

```
# If you need Docker to use an HTTP proxy, it can also be specified here.
export http_proxy="http://127.0.0.1:3128/"
```
