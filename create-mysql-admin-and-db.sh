#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

MYSTATUS=1

echo -n "Waiting to start mysql..."

while [[ MYSTATUS -ne 0 ]]; do
    echo -n "."
    sleep 1
    mysql -uroot -e "status" > /dev/null 2>&1
    MYSTATUS=$?
done

# Get password from Environment or create one

PASSWORD=${MYSQL_PASS:-$(pwgen -s 12 1)}

echo "Creating Admin for MySQL with Password ${PASSWORD} and Database for osTicket"

mysql -uroot -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY '$PASSWORD'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION"
mysql -uroot -e "CREATE DATABASE osticket"

echo "Done!"

echo "Database osticket has been created"
echo "You can now connect to osTicket and configure your database"
echo "********************** MySQL - DATA ***********************"
echo "*                                                         *"
echo "* DB-TABLE  :  osticket                                   *"
echo "* DB-USER   :  admin                                      *"
echo "* DB-PASS   :  ${PASSWORD}                                *"
echo "*                                                         *"
echo "***********************************************************"
mysqladmin -uroot shutdown
