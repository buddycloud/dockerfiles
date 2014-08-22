FROM ubuntu:14.04
RUN apt-get update

# Common dependencies
RUN apt-get install -y --no-install-recommends wget gdebi-core  

# Setup Database-layer
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -q install postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3
# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres
# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker
# Adjust PostgreSQL configuration so that remote connections to the
# database are possible. 
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf
# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf
# Expose the PostgreSQL port
EXPOSE 5432
# Switch back to root
USER root
RUN service postgresql restart 

# Setup XMPP-layer
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends prosody lua-zlib lua-cyrussasl
ADD config/prosody.cfg.lua               /etc/prosody/prosody.cfg.lua

# Setup buddycloud-layer
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openjdk-7-jre-headless dbconfig-common
RUN wget --quiet -O /tmp/buddycloud-server.deb http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-server-java/buddycloud-server-java_20140811.git.52de5d7-1/buddycloud-server-java_20140811.git.52de5d7-1_all.deb 
# ensure database is ready
ADD config/buddycloud-server-java.dbconfig.conf /etc/dbconfig-common/buddycloud-server-java.conf 

RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/buddycloud-server.deb
# update configuration files
ADD config/buddycloud-server-java-configuration.properties /usr/share/buddycloud-server-java/configuration.properties
ADD config/buddycloud-server-java-log4j.properties /usr/share/buddycloud-server-java/log4j.properties

# Setup web-layer
RUN apt-get install -y --no-install-recommends nodejs apache2 
RUN wget --quiet -O /tmp/http-api.deb http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-http-api/buddycloud-http-api_20140811.git.c3bc176-1/buddycloud-http-api_20140811.git.c3bc176-1_amd64.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/http-api.deb
RUN a2enmod rewrite proxy_http ssl headers expires deflate
ADD config/buddycloud-apache-virtual-host.conf /etc/apache2/sites-avaliable/buddycloud-apache-virtual-host.conf
ADD config/buddycloud-webclient-config.js      /usr/share/buddycloud-webclient/config.js
RUN a2enmod rewrite proxy_http ssl headers expires deflate
RUN a2ensite buddycloud-apache-virtual-host

EXPOSE 80 443 5222 5269

CMD ["/bin/bash"] 
