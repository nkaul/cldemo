#!/bin/bash
#do NOT set -e, since puppet will exit with error code 2

# check to see if root
if [ "$(whoami)" != "root" ]; then
	printf "Please run this with sudo or as root\n"
	exit 1
fi

printf "This may take a while, please be patient\n"

/usr/bin/puppet agent --test

# puppet exits with 2 if anything has changed
# only error if puppet exits with 1

puppet_return=$?

if [ "$puppet_return" = 1 ]; then
	printf "Please wait a short amount of time and try again\n \
		The initial puppet run has not yet completed \n"
	exit 1
fi


chown -R www-data:librenms /var/www/librenms
printf "Building librenms database now\n"
cd /var/www/librenms
/usr/bin/php /var/www/librenms/build-base.php
/usr/bin/php /var/www/librenms/adduser.php rocket turtle 10
service apache2 restart
exit 0
