#!/bin/bash
set -e

# check to see if root
if [ "$(whoami)" != "root" ]; then
	printf "Please run this with sudo or as root"
	exit 1
fi

printf "This may take a while, please be patient\n"

/usr/bin/puppet agent --test
chown -R www-data:librenms /var/www/librenms
printf "Building librenms database now\n"
cd /var/www/librenms
/usr/bin/php /var/www/librenms/build-base.php
service apache2 restart
exit 0
