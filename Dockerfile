FROM alpine:3.5

RUN apk add --no-cache \
  apache2 \
  curl \
  php5-apache2 \
  php5-dom \
  php5-exif \
  php5-iconv \
  php5-intl \
  php5-json \
  php5-ldap \
  php5-openssl \
  php5-pdo_mysql \
  php5-pdo_pgsql \
  php5-pgsql \
  php5-pspell \
  php5-sockets \
  php5-xml \
  php5-zip

RUN curl -L https://github.com/roundcube/roundcubemail/releases/download/1.2.5/roundcubemail-1.2.5-complete.tar.gz | \
    tar -C /srv -xzf - && \
  mv /srv/roundcubemail-1.2.5 /srv/roundcube && \
  chown root:www-data /srv/roundcube && \
  chown -R root:root /srv/roundcube/* && \
  chown -R root:www-data /srv/roundcube/.htaccess \
    /srv/roundcube/index.php \
    /srv/roundcube/robots.txt \
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
