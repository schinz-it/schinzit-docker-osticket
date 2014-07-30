#!/bin/bash

if [[ ! -d /var/lib/mysql/mysql ]]; then
    echo "Uninitialized MySQL directory found"
    echo "Installing MySQL..."
    mysql_install_db > /dev/null 2>&1
    echo "Done!"
    /create-mysql-admin-and-db.sh
fi

exec supervisord -n
