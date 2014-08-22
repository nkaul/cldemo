#!/bin/bash

function error() {
  echo -e "\e[0;33mERROR: Provisioning failed running $BASH_COMMAND at line $BASH_LINENO of $(basename $0) \e[0m" >&2
    exit 1
}

trap error ERR

# Add CFEngine repository
wget -qO- https://s3.amazonaws.com/cfengine.package-repos/pub/gpg.key | apt-key add -
echo "deb http://cfengine.com/pub/apt/packages stable main" > /etc/apt/sources.list.d/cfengine-community.list

# install cfengine
apt-get update -y
apt-get upgrade -y
apt-get install cfengine-community -y

# bootstrap against itself
/var/cfengine/bin/cf-agent --bootstrap 192.168.0.1

sleep 5

/var/cfengine/bin/cf-agent -K

sleep 5

/var/cfengine/bin/cf-agent -K

#CUMULUS-AUTOPROVISIONING

exit 0
