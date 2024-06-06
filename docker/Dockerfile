#####################################
## RUNTIME ##
FROM php:8.3-apache as runtime

RUN apt update && apt install libzip-dev libpng-dev -y
RUN docker-php-ext-install mysqli gd pdo_mysql

COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV APACHE_DOCUMENT_ROOT /var/www/public

COPY --chown=www-data ./ /var/www

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Enable nondefault php rewrite module
RUN a2enmod rewrite
