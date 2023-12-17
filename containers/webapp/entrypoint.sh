#!/bin/sh

cd /webapp
sh initialize-laravel.sh
php artisan "$@"
