FROM alpine:3.10

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

COPY httpd.conf /etc/apache2/conf.d/overrides.conf
COPY roundcube.asc /srv/roundcube.asc

ARG ROUNDCUBE_VERSION

RUN apk add --no-cache gnupg && \
  curl -fLO "https://github.com/roundcube/roundcubemail/releases/download/${ROUNDCUBE_VERSION}/roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz" && \
  curl -fLO "https://github.com/roundcube/roundcubemail/releases/download/${ROUNDCUBE_VERSION}/roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz.asc" && \
  gpg --import /srv/roundcube.asc && \
  gpg --verify "roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz.asc" "roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz" && \
  tar -C /srv -xzf "roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz" && \
  rm "roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz" "roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz.asc" && \
  apk del gnupg && \
  mv "/srv/roundcubemail-${ROUNDCUBE_VERSION}" /srv/roundcube && \
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

CMD httpd -DFOREGROUND
