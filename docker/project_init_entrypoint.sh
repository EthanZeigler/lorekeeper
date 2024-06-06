#!/bin/env bash

# Move to mounted directory
cd /var/www/
apt update && apt install git 7zip -y

# Install and run composer to install vendor packages
# https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
rm composer-setup.php

# Install vendor packages
COMPOSER_ALLOW_SUPERUSER=1 composer update \
    --no-interaction \
    --no-plugins \
    --no-scripts \
#    --no-dev \
    --prefer-dist


# Initial one-time setup commands
php artisan key:generate
php artisan migrate
php artisan add-site-settings
php artisan add-text-pages
php artisan copy-default-images
