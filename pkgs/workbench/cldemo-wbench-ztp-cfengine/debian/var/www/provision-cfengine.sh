#!/bin/bash

# Add CFEngine repository
wget -qO- https://s3.amazonaws.com/cfengine.package-repos/pub/gpg.key | apt-key add -
echo "deb http://cfengine.com/pub/apt/packages stable main" > /etc/apt/sources.list.d/cfengine-community.list

# install cfengine
apt-get update -y
apt-get upgrade -y
apt-get install cfengine-community -y

#CUMULUS-AUTOPROVISIONING

exit 0
