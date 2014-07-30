schinzit-docker-osticket
========================

Docker image for osticket

Usage
-----

To create the image schinz-it/osticket1.8, clone this repository and run in that folder

    docker build -t yourwantedimagename .

After building you can start the new image.

    docker run -d -p 80:80 -p 443:443 yourwantedimagename

MySQL Setup
-----------

MySQL setup is planed to use the user admin. To see what password has been set for admin use:

    docker logs $(docker ps -q)

There you should see some output like:

    DB-TABLE  :  osticket
    DB-USER   :  admin
    DB-PASS   :  sompassword

You can set a wanted password for user admin by setting env-variable MYSQL_PASS:

    docker run -d -p 80:80 -p443 -p443 -e MYSQL_PASS="somepass" yourwantedimagename

Configure osTicket
------------------

Now osTicket can be configured, just call the URL where the container is running

    e.g. https://osticket.yourdomain.org:443/

After setup you can save your container to an image

    docker commit $(docker ps -q) yourwantedname:conf

Complete configuration
----------------------

After these configurations 2 things should be done to your osTicket image:

* ost-config.php should be set to 664
* setup-directory should be deletet

To achieve that, you can create your own Dockerfile, with possible more changes you want.
That file could be like that

    FROM yourwantedname:conf
    
    RUN chmod 664 /var/www/html/include/ost-config.php
    RUN rm -rf /var/www/html/setup

    EXPOSE 80 443
    CMD [ "/startall.sh" ]

With that file you can rebuild image.
