FROM php:8.1.9-cli-alpine

# Install required librairies
RUN apk update && apk add autoconf g++ make git \
    unzip \
    postgresql-dev \
    libzip-dev \
    icu-dev \
    libxml2-dev \
    rabbitmq-c-dev

RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --quiet
RUN composer --version

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_pgsql zip intl bcmath sockets pcntl
RUN docker-php-ext-enable pcntl

RUN pecl install xdebug-3.1.5
RUN docker-php-ext-enable xdebug

RUN rm -rf /tmp/pear

RUN apk add --no-cache shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data

COPY ./conf.d /usr/local/etc/php/conf.d

USER www-data

WORKDIR /app
