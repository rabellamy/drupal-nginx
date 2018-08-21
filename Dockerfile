FROM alpine:3.8

RUN apk update && apk upgrade && apk --no-cache add bash \
  curl \
  g++ \
  git \
  make \
  mysql-client \
  nginx \
  php7 \
  php7-ctype \
  php7-curl \
  php7-dom \
  php7-fpm \
  php7-gd \
  php7-intl \
  php7-json \
  php7-mbstring \
  php7-mysqli \
  php7-pdo_mysql \
  php7-opcache \
  php7-openssl \
  php7-pdo \
  php7-phar \
  php7-session \
  php7-simplexml \
  php7-sockets \
  php7-tokenizer \
  php7-xml \
  php7-xmlreader \
  php7-xmlwriter \
  php7-zlib \
  openssh \
  supervisor

RUN curl --silent --output /tmp/composer-setup.php https://getcomposer.org/installer \
  && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer \
  && rm /tmp/composer-setup.php

# For Drush major versions see http://docs.drush.org/en/master/install/ and for
# exact versions see https://github.com/drush-ops/drush/releases.
ENV DRUSH_VERSION ${DRUSH_VERSION:-8.1.17}
RUN composer global require drush/drush:"$DRUSH_VERSION" --prefer-dist \
  && ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush

RUN drush init -y

# nginx
COPY docker/conf/nginx.conf /etc/nginx/nginx.conf

# PHP-FPM
COPY docker/conf/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY docker/conf/php.ini /etc/php7/conf.d/zzz_custom.ini

# Supervisord
COPY docker/conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add source code
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
COPY ./ /var/www/html/

RUN chmod -R 777 /var/www/html/web/sites/default/files

RUN composer install

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
