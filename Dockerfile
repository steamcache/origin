FROM nginx:alpine
MAINTAINER SteamCache.Net Team <team@steamcache.net>

COPY overlay/ /

VOLUME [ "/data" ]

EXPOSE 80

ENTRYPOINT [ "steamcache-generic" ]
