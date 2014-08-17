FROM aostanin/debian

RUN apt-get install -qy gdebi-core

ADD http://downloads.plexapp.com/plex-media-server/0.9.9.14.531-7eef8c6/plexmediaserver_0.9.9.14.531-7eef8c6_amd64.deb /tmp/plexmediaserver.deb
RUN gdebi -qn /tmp/plexmediaserver.deb && rm /tmp/plexmediaserver.deb

ADD start.sh /start.sh
RUN chmod a+rx /start.sh

EXPOSE 32400

CMD ["/start.sh"]
