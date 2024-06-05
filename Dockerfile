FROM composer:2.0 as vendor

WORKDIR /app

COPY ./composer.json ./composer.json
COPY ./composer.lock ./composer.lock

RUN composer update
RUN composer install
    # --no-interaction \
    # --no-plugins \
    # --no-scripts \
    # --no-dev \
    # --prefer-dist

COPY . .
RUN composer dump-autoload

##################################################
FROM php:8.3-fpm AS setup
RUN apt update && apt install git 7zip -y
COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY ./composer.json ./composer.json
COPY ./composer.lock ./composer.lock

ENV COMPOSER_ALLOW_SUPERUSER=1
COPY ./database ./database
RUN composer install \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --no-dev \
    --prefer-dist
#COPY --from=vendor /app /var/www

FROM php:8.3-apache
COPY . /var/www
COPY --from=setup ./ /var/www/

ENV APACHE_DOCUMENT_ROOT /var/www/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN a2enmod rewrite
