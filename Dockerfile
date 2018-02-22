FROM php:5.6-fpm-alpine
MAINTAINER bingo <bingov5@icloud.com>

ENV PHPREDIS_VERSION 4.0.0RC1

# install iconv, mcrypt, gd, pdo_mysql, redis
RUN apk add --no-cache --virtual .build-ext-deps \
         curl \
         coreutils \
         freetype-dev \
         libjpeg-turbo-dev \
         libltdl \
         libmcrypt-dev \
         libpng-dev \
    && curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mkdir -p /usr/src/php/ext \
    && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install redis \
    && rm -rf /usr/src/php \
    && apk del .build-ext-deps
