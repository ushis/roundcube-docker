FROM alpine:3.10

ARG ROUNDCUBE_VERSION=1.3.9

RUN apk add --no-cache \
  apache2 \
  curl \
  php7 \
  php7-apache2 \
  php7-dom \
  php7-exif \
  php7-fileinfo \
  php7-iconv \
  php7-intl \
  php7-json \
  php7-ldap \
  php7-mbstring \
  php7-openssl \
  php7-pdo_mysql \
  php7-pdo_pgsql \
  php7-openssl \
  php7-pgsql \
  php7-pspell \
  php7-session \
  php7-sockets \
  php7-xml \
  php7-zip

RUN curl -L https://github.com/roundcube/roundcubemail/releases/download/$ROUNDCUBE_VERSION/roundcubemail-$ROUNDCUBE_VERSION-complete.tar.gz | \
    tar -C /srv -xzf - && \
  mv /srv/roundcubemail-$ROUNDCUBE_VERSION /srv/roundcube && \
  chown root:www-data /srv/roundcube && \
  chown -R root:root /srv/roundcube/* && \
  chown -R root:www-data \
    /srv/roundcube/.htaccess \
    /srv/roundcube/index.php \
    /srv/roundcube/config \
    /srv/roundcube/logs \
    /srv/roundcube/plugins \
    /srv/roundcube/program \
    /srv/roundcube/skins \
    /srv/roundcube/temp \
    /srv/roundcube/vendor && \
  find /srv/roundcube -type d -exec chmod 0750 {} \; && \
  find /srv/roundcube -type f -exec chmod 0640 {} \; && \
  chmod -R 0770 /srv/roundcube/logs /srv/roundcube/temp

COPY httpd.conf /etc/apache2/conf.d/overrides.conf

CMD httpd -DFOREGROUND
