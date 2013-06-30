#!/usr/bin/env bash

# Set up apache
apt-get update
apt-get install -y apache2
rm -rf /var/www
ln -s /vagrant/web /var/www

# Set up php
apt-get install -y php5=5.3.10-1ubuntu3.6 php5-mysql

# Set up mysql
# DEBIAN_FRONTEND=noninteractive apt-get install -y -q mysql-server
# MYSQL_TABLE=hg
# MYSQL_USER=hguser
# MYSQL_USER_PASSWORD=i25iyOnACVax5y3NQAn
# MYSQL_ROOT_PASSWORD=CBdL7HhUJO0GOUpNIM1
# mysqladmin -u root create ${MYSQL_TABLE}
# mysql -u root -e "GRANT ALL PRIVILEGES ON ${MYSQL_TABLE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_USERPASSWORD}'"
# mysqladmin -u root password ${MYSQL_ROOT_PASSWORD}

