FROM ubuntu:14.04
MAINTAINER Ulrich Schinz <info@schinz.it>

# upgrade and install Packages
RUN DEBIAN_FRONTENT=noninteractive apt-get update && apt-get -y upgrade 
RUN DEBIAN_FRONTENT=noninteractive apt-get -y install supervisor pwgen git php5 php5-mysql mysql-server apache2 php5-gd php-gettext php5-imap php-services-json php-xml-parser php-apc php5-imap

# Add configs and startscripts
ADD start-apache.sh /start-apache.sh
ADD start-mysql.sh /start-mysql.sh
ADD startall.sh /startall.sh
ADD apache-supervisor.conf /etc/supervisor/conf.d/apache-supervisor.conf
ADD mysql-supervisor.conf /etc/supervisor/conf.d/mysql-supervisor.conf

ADD create-mysql-admin-and-db.sh /create-mysql-admin-and-db.sh
RUN chmod 755 /*.sh

# Remove initial Databases
RUN rm -rf /var/lib/mysql/*

# Install osTicket
RUN git clone https://github.com/osTicket/osTicket-1.8 /usr/local/src/osTicket-1.8

# for develop-release
# RUN cd /usr/local/src/osTicket-1.8 && git checkout remotes/origin/develop-next

# clean html directory
RUN rm -rf /var/www/html/*

# install osticket
RUN php /usr/local/src/osTicket-1.8/setup/cli/manage.php deploy --setup /var/www/html

# remove source-files
RUN rm -rf /usr/local/src/*

# prepare config
RUN cp /var/www/html/include/ost-sampleconfig.php /var/www/html/include/ost-config.php
RUN chmod 0666 /var/www/html/include/ost-config.php

# enable https
RUN a2ensite default-ssl
RUN a2enmod ssl

EXPOSE 80 443

CMD [ "/startall.sh" ]
