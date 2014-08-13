#!/bin/bash
set -e

# check to see if root
if [ "$(whoami)" != root]; then
	printf "Please run this with sudo or as root"
	exit 1
fi

printf "This may take a while, please be patient\n"
# sleep to allow puppet run to create librenms user and group
# doing this in a script instead of puppet as large puppet run 
# seems to encourage build-base.php to fail
/usr/bin/puppet agent --test
chown -R librenms:www-data /var/www/librenms
printf "Building librenms database now\n"
/usr/bin/php /var/www/librenms/build-base.php
exit 0
