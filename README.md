Buddycloud ♥ Docker
===================

A dockerfile to run the Buddycloud stack components:
* Buddycloud web-app
* REST and webscocket http-API and xmpp-ftw
* Buddycloud Server
* Media Server
* a Prosody server (but can work against an existing server)

This Dockerfile configures a Buddycloud stack by copying the contents of the `config` directory into the container. It will also preserve your existing data using the Docker `VOLUME` and `-v` config and runtime options.

## Setup

* Install Docker on your system
* `git clone git@github.com:buddycloud/dockerfiles.git`
* `cd dockerfiles/buddycloud-stack`
* `docker  build -t buddycloud-stack .`

## Launching

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

### buddycloud.dev (a testing domain)

The existing Dockerfile will _just work_

The Dockerfile runs a nameserver that resolves the different buddycloud components. 

All you need to do is add `buddycloud.dev` resolve to `localhost`

```bash
echo "127.0.0.1 buddycloud.dev" >> /etc/hosts
```

### your-domain.com (uses Dockerfile XMPP server)

Configure the stack for your own domain using `find ./config -type f -exec sed -i -e 's/buddycloud.dev/your-domain.com/g' {} \;`

* unconfigure the included bind server @abmar ???

### your-domain.com (runs against your existing XMPP server)

* configure the stack for your own domain using `find ./config -type f -exec sed -i -e 's/buddycloud.dev/mydomain.com/g' {} \;`
* change the existing components to point at your xmpp server... @abmar how?
