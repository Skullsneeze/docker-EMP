FROM php:7.2-fpm

# PHP Extension setup
RUN apt-get update && apt-get install -y \
        zlib1g-dev libicu-dev g++ \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libmcrypt-dev \
        libxslt-dev \
        libmemcached-dev \
        libtidy-dev \
        libssl-dev \
        openssh-server \
        gnupg2 \
        wkhtmltopdf libfontconfig1 libxrender1 \
        curl \
        git \
        cron \
        nano

RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr
RUN docker-php-ext-configure intl

RUN docker-php-ext-install \
    bcmath \
    calendar \
    exif \
    gd \
    gettext \
    mysqli \
    pdo_mysql \
    soap \
    sockets \
    tidy \
    intl \
    wddx \
    xmlrpc \
    xsl \
    zip

# mcrypt
RUN pecl install mcrypt-1.0.2 \
    && docker-php-ext-enable mcrypt

# Composer installation
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --version

# Install xdebug
RUN pecl install xdebug-2.9.1 \
    && docker-php-ext-enable xdebug
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# OPCache
RUN docker-php-ext-enable opcache
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Memcache
RUN pecl install memcached && docker-php-ext-enable memcached

# Mage php ini
ADD ./mage2.ini /usr/local/etc/php/conf.d
COPY www.conf /usr/local/etc/php-fpm.d/

# docker-compose exec php-fpm magento --> php bin/magento
RUN echo '#!/bin/bash\n/usr/local/bin/php /var/www/bin/magento "$@"' > /usr/bin/magento
RUN chmod +x /usr/bin/magento
# docker-compose exec php-fpm phpunit --> php vendor/bin/phpunit
RUN echo '#!/bin/bash\n/usr/local/bin/php /var/www/vendor/bin/phpunit "$@"' > /usr/bin/phpunit
RUN chmod +x /usr/bin/phpunit
# docker-compose exec php-fpm magerun --> php vendor/bin/n98-magerun2
RUN echo '#!/bin/bash\n/usr/local/bin/php /var/www/vendor/bin/n98-magerun2 "$@"' > /usr/bin/magerun
RUN chmod +x /usr/bin/magerun

EXPOSE 9000
CMD ["php-fpm"]