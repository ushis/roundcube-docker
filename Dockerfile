FROM php:apache

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    libpq-dev \
    libicu-dev \
    libldap2-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu && \
  docker-php-ext-install pdo pdo_mysql pdo_pgsql zip intl exif ldap && \
  a2enmod rewrite deflate headers expires

RUN rm -rf /var/www/html && \
  curl -L https://github.com/roundcube/roundcubemail/releases/download/1.2.3/roundcubemail-1.2.3-complete.tar.gz | tar -C /var/www -xzf - && \
  mv /var/www/roundcubemail-1.2.3 /var/www/html && \
  chown root:www-data /var/www/html && \
  chown -R root:root /var/www/html/* && \
  chown -R root:www-data /var/www/html/.htaccess \
    /var/www/html/index.php \
    /var/www/html/robots.txt \
    /var/www/html/config \
    /var/www/html/logs \
    /var/www/html/plugins \
    /var/www/html/program \
    /var/www/html/skins \
    /var/www/html/temp \
    /var/www/html/vendor && \
  find /var/www/html -type d -exec chmod 0750 {} \; && \
  find /var/www/html -type f -exec chmod 0640 {} \; && \
  chmod -R 0770 /var/www/html/logs /var/www/html/temp
