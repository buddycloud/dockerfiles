# This Dockerfile sets up the Buddycloud stack from the database layer
# all the way up to the webserver, API and user-facing webclient

FROM ubuntu:14.04
RUN apt-get update

ENV DEBIAN_FRONTEND noninteractive

# we try to log everything into one directory
RUN mkdir /var/log/buddycloud && chmod a+rx /var/log/buddycloud

# Common dependencies
RUN apt-get install -y --no-install-recommends wget  

# Setup Database-layer
RUN apt-get -y -q install --no-install-recommends postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres
# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN service postgresql start && psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker
# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/9.3/main/pg_hba.conf
# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf
# Switch back to root
USER root
# Add VOLUMEs to allow backup of databases
VOLUME  ["/var/lib/postgresql"]

# Setup XMPP-layer
RUN apt-get install -y --no-install-recommends prosody lua-zlib lua-cyrussasl lua-sec
ADD config/prosody.cfg.lua /etc/prosody/prosody.cfg.lua
RUN touch /var/log/buddycloud/prosody.log /var/log/buddycloud/prosody.err
RUN chown prosody /var/log/buddycloud/prosody.log /var/log/buddycloud/prosody.err

# Setup buddycloud-layer
RUN apt-get install -y --no-install-recommends openjdk-7-jre-headless dbconfig-common
ADD http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-server-java/buddycloud-server-java_latest.deb  /tmp/buddycloud-server.deb 
# ensure database is ready
ADD config/buddycloud-server-java.dbconfig.conf /etc/dbconfig-common/buddycloud-server-java.conf 
# install debian package
RUN service postgresql start && dpkg -i /tmp/buddycloud-server.deb
# update configuration files
ADD config/buddycloud-server-java-configuration.properties /usr/share/buddycloud-server-java/configuration.properties
ADD config/buddycloud-server-java-log4j.properties /usr/share/buddycloud-server-java/log4j.properties

# Setup buddycloud-media-server
ADD http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-media-server/buddycloud-media-server_latest.deb  /tmp/buddycloud-media-server.deb 
# ensure database is ready
ADD config/buddycloud-media-server.dbconfig.conf /etc/dbconfig-common/buddycloud-media-server.conf 
# install debian package
RUN service postgresql start && dpkg -i /tmp/buddycloud-media-server.deb
# update configuration files
ADD config/buddycloud-media-server-configuration.properties /usr/share/buddycloud-media-server/mediaserver.properties
ADD config/buddycloud-media-server-log4j.xml /usr/share/buddycloud-server-java/logback.xml
# create media server XMPP client account
ADD bin/buddycloud-media-server-create-user.sh /tmp/buddycloud-media-server-create-user.sh
RUN service prosody start && /bin/bash /tmp/buddycloud-media-server-create-user.sh
# create storage dir and give proper permissions
RUN mkdir -p /var/lib/media-storage; chown -R buddycloud:buddycloud /var/lib/media-storage

# Setup Apache
RUN apt-get install -y --no-install-recommends apache2 
# these are keys for *.buddycloud.dev. Prosody will also use them.
ADD config/buddycloud.dev.cert.pem    /etc/apache2/certs/
ADD config/buddycloud.dev.key.pem     /etc/apache2/certs/

# Setup http-api
RUN apt-get install -y --no-install-recommends nodejs
ADD http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-http-api/buddycloud-http-api_latest.deb /tmp/http-api.deb 
RUN dpkg -i /tmp/http-api.deb
ADD config/buddycloud-http-api-config.js /usr/share/buddycloud-http-api/config.js

# Setup Buddycloud Webclient
ADD http://downloads.buddycloud.com/packages/debian/nightly/webclient/webclient_latest.deb /tmp/webclient.deb 
RUN dpkg -i /tmp/webclient.deb
ADD config/buddycloud-webclient-config.js      /usr/share/buddycloud-webclient/config.js
ADD config/buddycloud-apache-virtual-host.conf /etc/apache2/sites-available/buddycloud-apache-virtual-host.conf
RUN a2enmod proxy_wstunnel rewrite ssl headers expires
RUN a2dissite buddycloud-apache-virtual-host
RUN a2ensite buddycloud-apache-virtual-host

EXPOSE 80 443 5222 5269

ENTRYPOINT service postgresql start && service prosody start && \
           /etc/init.d/buddycloud-server-java start && /etc/init.d/buddycloud-media-server start && \
           service apache2 restart && /etc/init.d/buddycloud-http-api start; /bin/bash
