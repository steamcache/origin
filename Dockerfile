FROM nginx:alpine
MAINTAINER SteamCache.Net Team <team@steamcache.net>

ENV GENERICCACHE_VERSION 1
ENV WEBUSER nginx
ENV CACHE_MEM_SIZE 500m
ENV CACHE_DISK_SIZE 500000m
ENV CACHE_MAX_AGE 3560d
ENV CACHE_MONOLITHIC false
ENV CACHE_DOMAIN_REPO https://github.com/uklans/cache-domains.git
ENV BEAT_TIME 1h

COPY overlay/ /

RUN    chmod 755 /scripts/*                ;\
    mkdir -m 755 -p /data/cache            ;\
    mkdir -m 755 -p /data/info             ;\
    mkdir -m 755 -p /data/logs             ;\
    mkdir -m 755 -p /data/cachedomains     ;\
    mkdir -m 755 -p /tmp/nginx/            ;\
    chown -R ${WEBUSER}:${WEBUSER} /data/  ;\
    mkdir -p /etc/nginx/sites-enabled      ;\
    apk add jq git                         ;\
    mkdir -p /etc/nginx/sites-enabled      ;\
    ln -s /etc/nginx/sites-available/generic.conf /etc/nginx/sites-enabled/generic.conf

VOLUME ["/data/logs", "/data/cache", "/data/cachedomains", "/var/www"]

EXPOSE 80

WORKDIR /scripts

ENTRYPOINT ["/scripts/bootstrap.sh"]
