#!/bin/bash
set -e

# Preprocess UPSTREAM_DNS to allow for multiple resolvers using the same syntax as lancache-dns
UPSTREAM_DNS="$(echo -n "${UPSTREAM_DNS}" | sed 's/[;]/ /g')"

echo "worker_processes ${NGINX_WORKER_PROCESSES};" > /etc/nginx/workers.conf
sed -i "s/^user .*/user ${WEBUSER};/" /etc/nginx/nginx.conf
sed -i "s/CACHE_MEM_SIZE/${CACHE_MEM_SIZE}/" /etc/nginx/conf.d/20_proxy_cache_path.conf
sed -i "s/CACHE_DISK_SIZE/${CACHE_DISK_SIZE}/" /etc/nginx/conf.d/20_proxy_cache_path.conf
sed -i "s/CACHE_MAX_AGE/${CACHE_MAX_AGE}/" /etc/nginx/sites-available/generic.conf.d/root/20_cache.conf
sed -i "s/slice 1m;/slice ${CACHE_SLICE_SIZE};/" /etc/nginx/sites-available/generic.conf.d/root/20_cache.conf
if [[ ${ENABLE_IPV6} != "true" ]]; then
  sed -i "s/UPSTREAM_DNS/${UPSTREAM_DNS} ipv6=off/" /etc/nginx/sites-available/generic.conf.d/10_generic.conf
  sed -i "/ENABLE_IPV6/d" /etc/nginx/sites-available/10_generic.conf
else
  sed -i "s/UPSTREAM_DNS/${UPSTREAM_DNS}/" /etc/nginx/sites-available/generic.conf.d/10_generic.conf
  sed -i "s/ENABLE_IPV6/listen [::]:80 reuseport/" /etc/nginx/sites-available/10_generic.conf
fi
