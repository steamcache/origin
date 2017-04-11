FROM nginx:alpine
MAINTAINER SteamCache.Net Team <team@steamcache.net>

COPY overlay/ /

RUN	mkdir -p /etc/nginx/sites-enabled ;\
	ln -s /etc/nginx/sites-available/steamcache.conf /etc/nginx/sites-enabled/steamcache.conf

VOLUME [ "/data" ]

EXPOSE 80

ENTRYPOINT [ "steamcache-generic" ]
