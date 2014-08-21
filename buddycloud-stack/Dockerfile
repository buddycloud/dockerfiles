FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install -y --no-install-recommends wget gdebi-core openjdk-7-jre-headless prosody lua-zlib lua-cyrussasl prosody postgresql postgresql-client postgresql-contrib dbconfig-common nodejs apache2 
RUN a2enmod rewrite proxy_http ssl headers expires deflate

RUN wget --quiet -O /tmp/http-api.deb http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-http-api/buddycloud-http-api_20140811.git.c3bc176-1/buddycloud-http-api_20140811.git.c3bc176-1_amd64.deb
RUN wget --quiet -O /tmp/buddycloud-server.deb http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-server-java/buddycloud-server-java_20140811.git.52de5d7-1/buddycloud-server-java_20140811.git.52de5d7-1_all.deb 

RUN gdebi -qn /tmp/http-api.deb /tmp/buddycloud-server.deb

# Setup web-layer
RUN gdebi -qn /tmp/http-api.deb
RUN a2enmod rewrite proxy_http ssl headers expires deflate
ADD config/buddycloud-apache-virtual-host.conf /etc/apache2/sites-enabled/
ADD config/buddycloud-webclient-config.js      /usr/share/buddycloud-webclient/config.js
RUN a2ensite buddycloud-apache-virtual-host

# Setup buddycloud-layer
ADD config/certificate.pem               /etc/ssl/certificate.pem
ADD config/buddycloud-server.cfg         /etc/prosody/prosody.cfg.lua
ADD config/http-api-config.js            /etc/buddycloud-http-api/config.js

# Setup XMPP-layer
RUN apt-get -y --no-install-recommends prosody lua-zlib lua-cyrussasl
ADD config/prosody.cfg.lua               /etc/prosody/prosody.cfg.lua


EXPOSE 80 443 5222 5269

CMD ["/bin/bash"] 
