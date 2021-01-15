FROM lancachenet/ubuntu-nginx:latest
MAINTAINER LanCache.Net Team <team@lancache.net>

ENV GENERICCACHE_VERSION=2 \    
    WEBUSER=www-data \
	CACHE_MODE=generic \
    CACHE_INDEX_SIZE=500m \
    CACHE_DISK_SIZE=1000000m \
    CACHE_MAX_AGE=3560d \
	CACHE_SLICE_SIZE=1m \
    UPSTREAM_DNS="8.8.8.8 8.8.4.4" \
    BEAT_TIME=1h \
    LOGFILE_RETENTION=3560 \
    NGINX_WORKER_PROCESSES=16

COPY overlay/ /

RUN rm /etc/nginx/sites-enabled/* /etc/nginx/stream-enabled/* ;\
    rm /etc/nginx/conf.d/gzip.conf ;\
    chmod 754  /var/log/tallylog ; \
    id -u ${WEBUSER} &> /dev/null || adduser --system --home /var/www/ --no-create-home --shell /bin/false --group --disabled-login ${WEBUSER} ;\
    chmod 755 /scripts/*			;\
	mkdir -m 755 -p /data/cache		;\
	mkdir -m 755 -p /data/info		;\
	mkdir -m 755 -p /data/logs		;\
	mkdir -m 755 -p /tmp/nginx/		;\
	chown -R ${WEBUSER}:${WEBUSER} /data/	;\
	mkdir -p /etc/nginx/sites-enabled	;\
	ln -s /etc/nginx/sites-available/10_generic.conf /etc/nginx/sites-enabled/10_generic.conf; \
	ln -s /etc/nginx/stream-available/10_sni.conf /etc/nginx/stream-enabled/10_sni.conf

VOLUME ["/data/logs", "/data/cache", "/var/www"]

EXPOSE 80 443

WORKDIR /scripts
