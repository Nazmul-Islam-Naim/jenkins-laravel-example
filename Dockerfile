FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    zip unzip curl git \
    && docker-php-ext-install pdo_mysql

WORKDIR /var/www/html

COPY . .

RUN curl -sS https://getcomposer.org/installer | php \
    && php composer.phar install --no-dev --optimize-autoloader

CMD ["php-fpm"]
