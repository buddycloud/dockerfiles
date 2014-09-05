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

### http://buddycloud.dev (good for developing without a real Domain)

The Dockerfile runs a nameserver that resolves the different buddycloud components. 

Setup

```bash
echo "127.0.0.1 buddycloud.dev" >> /etc/hosts
```

Then go to http://buddycloud.dev

### http://your-domain.com (uses the included XMPP server)

Configure the stack for your own domain using `find ./config -type f -exec sed -i -e 's/buddycloud.dev/your-domain.com/g' {} \;`


### http://your-domain.com (uses your XMPP server)

* configure the stack for your own domain using `find ./config -type f -exec sed -i -e 's/buddycloud.dev/your-domain.com/g' {} \;`
* configure the Buddycloud server component to point to your server IP. (variable is `xmpp.host` in  [buddycloud-server-java-configuration.properties](https://github.com/buddycloud/dockerfiles/blob/master/buddycloud-stack/config/buddycloud-server-java-configuration.properties))
* configure the Buddycloud media server component to point to your server IP. (variable is `xmpp.component.host` in [buddycloud-media-server-configuration.properties](https://github.com/buddycloud/dockerfiles/blob/master/buddycloud-stack/config/buddycloud-media-server-configuration.properties)
* rebuild your Dockerfile
* configure your [DNS for Buddycloud](http://buddycloud.com/install#buddycloud_dns_)
* Then go to http://buddycloud.{your-domain}.com
