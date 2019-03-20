FROM ubuntu:latest

# Install apache, PHP, and supplimentary programs. openssh-server, curl, and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install curl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install nano
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php-sqlite3
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libapache2-mod-php

RUN a2enmod php7.2
RUN a2enmod rewrite

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

RUN   rm /etc/apache2/sites-available/000-default.conf
RUN   touch /etc/apache2/sites-available/000-default.conf

RUN mkdir /web
RUN chown -R www-data:www-data /web
RUN chmod -R 775 /web

RUN   echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/000-default.conf
RUN   echo "    ServerAdmin root@yourserver.com" >> /etc/apache2/sites-available/000-default.conf
RUN   echo "    DocumentRoot /web/public" >> /etc/apache2/sites-available/000-default.conf
RUN   echo "    ErrorLog /web/error.log" >> /etc/apache2/sites-available/000-default.conf
RUN   echo "    CustomLog /web/access.log combined" >> /etc/apache2/sites-available/000-default.conf
RUN   echo "    php_admin_value error_log /web/php.error.log" >> /etc/apache2/sites-available/000-default.conf
RUN   echo "    <Directory />" >> /etc/apache2/sites-available/000-default.conf
RUN   echo "        Options Indexes FollowSymLinks MultiViews" >> /etc/apache2/sites-available/000-default.conf
RUN   echo "        AllowOverride All" >> /etc/apache2/sites-available/000-default.conf
RUN   echo "        Require all granted" >> /etc/apache2/sites-available/000-default.conf
RUN   echo "    </Directory>" >> /etc/apache2/sites-available/000-default.conf
RUN   echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf

VOLUME ["/web"]

# Expose apache.
EXPOSE 80/tcp
EXPOSE 443/tcp

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
