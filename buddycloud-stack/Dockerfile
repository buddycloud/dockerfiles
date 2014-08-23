# This Dockerfile sets up the Buddycloud stack from the database layer
# all the way up to the webserver, API and user-facing webclient

FROM ubuntu:14.04
RUN apt-get update

# Common dependencies
RUN apt-get install -y --no-install-recommends wget  

# Setup Database-layer
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -q install postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres
# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN /etc/init.d/postgresql start && psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/9.3/main/pg_hba.conf
# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Switch back to root
USER root
RUN netstat -panute

# Setup XMPP-layer
RUN apt-get install -y --no-install-recommends prosody lua-zlib lua-cyrussasl
ADD config/prosody.cfg.lua /etc/prosody/prosody.cfg.lua
RUN service prosody restart

# Setup buddycloud-layer
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openjdk-7-jre-headless dbconfig-common
RUN wget --quiet -O /tmp/buddycloud-server.deb http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-server-java/buddycloud-server-java_latest.deb 
# ensure database is ready
ADD config/buddycloud-server-java.dbconfig.conf /etc/dbconfig-common/buddycloud-server-java.conf 
# install debian package
RUN /etc/init.d/postgresql start && DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/buddycloud-server.deb
# update configuration files
ADD config/buddycloud-server-java-configuration.properties /usr/share/buddycloud-server-java/configuration.properties
ADD config/buddycloud-server-java-log4j.properties /usr/share/buddycloud-server-java/log4j.properties

# Setup Apache
RUN apt-get install -y --no-install-recommends apache2 
ADD config/buddycloud.dev.cert.pem    /etc/apache2/certs/
ADD config/buddycloud.dev.key.pem     /etc/apache2/certs/
RUN service apache2 start

# Setup http-api
RUN apt-get install -y --no-install-recommends nodejs
RUN wget --quiet -O /tmp/http-api.deb http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-http-api/buddycloud-http-api_latest.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/http-api.deb
ADD config/buddycloud-apache-virtual-host.conf /etc/apache2/sites-available/buddycloud-apache-virtual-host.conf
RUN a2enmod proxy_wstunnel rewrite ssl headers expires
RUN a2ensite buddycloud-apache-virtual-host
RUN service apache2 restart

# Setup Buddycloud Webclient
RUN wget --quiet -O /tmp/webclient.deb http://downloads.buddycloud.com/packages/debian/nightly/webclient/webclient_latest.deb
RUN DEBIAN_FRONTED=noninteractive dpkg -i /tmp/webclient.deb
ADD config/buddycloud-webclient-config.js      /usr/share/buddycloud-webclient/config.js


EXPOSE 80 443 5222 5269

ENTRYPOINT /etc/init.d/postgresql start && /etc/init.d/prosody start && \
           /etc/init.d/buddycloud-server-java start && service apache2 start && \
           /etc/init.d/buddycloud-http-api start && /bin/sh -c
CMD ["/bin/bash"] 
