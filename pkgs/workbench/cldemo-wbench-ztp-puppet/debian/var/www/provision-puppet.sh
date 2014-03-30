#!/bin/bash
apt-get update -y
apt-get upgrade -y
apt-get install puppet -y
echo "Configuring puppet" | wall -n
sed -i /etc/default/puppet -e 's/START=no/START=yes/'
sed -i /etc/puppet/puppet.conf -e 's/\[main\]/\[main\]\npluginsync=true/'
service puppet restart
# CUMULUS-AUTOPROVISIONING
exit 0
