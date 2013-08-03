#!/usr/bin/env bash

# Set up php
apt-get update
apt-get install -y php5 php5-mysql

# Set up apache
apt-get install -y apache2
rm -rf /var/www
ln -s /vagrant/web /var/www

# Save mysql connection info to httpd.conf
source /vagrant/provision/secret.sh
echo "SetEnv MYSQL_DB ${MYSQL_DB}" >> /etc/apache2/httpd.conf
echo "SetEnv MYSQL_USER ${MYSQL_USER}" >> /etc/apache2/httpd.conf
echo "SetEnv MYSQL_USER_PASSWORD ${MYSQL_USER_PASSWORD}" >> /etc/apache2/httpd.conf

# Set up mysql
DEBIAN_FRONTEND=noninteractive apt-get install -y -q mysql-server
mysqladmin -uroot create ${MYSQL_DB}
mysql -u root -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_USER_PASSWORD}'"
mysql -u${MYSQL_USER} -p${MYSQL_USER_PASSWORD} ${MYSQL_DB} < /vagrant/provision/hg-database.sql
mysqladmin -uroot password ${MYSQL_ROOT_PASSWORD}

# Restart apache so the php extensions will be used
service apache2 restart
