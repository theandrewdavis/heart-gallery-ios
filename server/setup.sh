#!/usr/bin/env bash

# Set up apache
apt-get update
apt-get install -y apache2
rm -rf /var/www
ln -s /vagrant/web /var/www

# Set up php
apt-get install -y php5=5.3.10-1ubuntu3.6 php5-mysql

# mysql connection info
MYSQL_DB=hg
MYSQL_USER=hguser
MYSQL_USER_PASSWORD=i25iyOnACVax5y3NQAn
MYSQL_ROOT_PASSWORD=CBdL7HhUJO0GOUpNIM1

# Set up mysql
DEBIAN_FRONTEND=noninteractive apt-get install -y -q mysql-server
mysqladmin -uroot create ${MYSQL_DB}
mysql -u root -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_USER_PASSWORD}'"
mysql -u${MYSQL_USER} -p${MYSQL_USER_PASSWORD} ${MYSQL_DB} < /vagrant/hg-database.sql
mysqladmin -uroot password ${MYSQL_ROOT_PASSWORD}

