#!/bin/sh
# Ensure run this script as root

set -o xtrace

cd /webapp

ls -al

RUN mkdir -p storage/ \
  && mkdir -p storage/app/public \
  && mkdir -p storage/framework \
  && mkdir -p storage/framework/cache \
  && mkdir -p storage/framework/sessions \
  && mkdir -p storage/framework/testing \
  && mkdir -p storage/framework/views \
  && mkdir -p storage/logs \
  && mkdir -p bootstrap/cache \
  && chown -R www-data:www-data storage/ \
  && chown -R root bootstrap/

chown -R www-data:www-data bootstrap/cache/ storage/

if [ -n "$APP_ENV" ]; then
  php artisan config:cache --env $APP_ENV
else
  php artisan config:cache
fi

php artisan storage:link
