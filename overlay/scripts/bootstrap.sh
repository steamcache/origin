#!/bin/sh
set -e

sed -i "s/CACHE_MEM_SIZE/${CACHE_MEM_SIZE}/"  /etc/nginx/sites-available/generic.conf
sed -i "s/CACHE_DISK_SIZE/${CACHE_DISK_SIZE}/" /etc/nginx/sites-available/generic.conf
sed -i "s/CACHE_MAX_AGE/${CACHE_MAX_AGE}/"    /etc/nginx/sites-available/generic.conf

echo "Checking permissions (This may take a long time if the permissions are incorrect on large caches)..."
find /data \! -user ${WEBUSER} -exec chown ${WEBUSER}:${WEBUSER} '{}' +

env

if [ "$CACHE_MONOLITHIC" = "true" ]; then
	echo "Generating up-to-date cache mappings"
	/bin/sh /scripts/generate-maps.sh
	sed -ri 's/proxy_cache_key(\s+)\$uri/proxy_cache_key\1$cacheidentifier\/$uri/'  /etc/nginx/sites-available/generic.conf
fi

echo "Done. Starting caching server."

/usr/sbin/nginx -t

./heartbeat.sh ${BEAT_TIME} &

/usr/sbin/nginx -g "daemon off;"
