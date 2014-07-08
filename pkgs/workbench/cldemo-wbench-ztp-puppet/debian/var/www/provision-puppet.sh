#!/bin/bash

# Allow Cumulus testing repo
sed -i /etc/apt/sources.list -e 's/# deb http:\/\/repo.cumulusnetworks.com CumulusLinux-2.1 testing/deb http:\/\/repo.cumulusnetworks.com CumulusLinux-2.1 testing/'

# Add PuppetLabs repo
wget -o /tmp/puppetlabs-pubkey.gpg http://apt.puppetlabs.com/pubkey.gpg
gpg --import /tmp/puppetlabs-pubkey.gpg
gpg -a --export 4BD6EC30 | apt-key add -

# Upgrade and install Puppet
apt-get update -y
apt-get upgrade -y
apt-get install puppet -y

echo "Configuring puppet" | wall -n
sed -i /etc/default/puppet -e 's/START=no/START=yes/'

# Commenting out pluginsync until plugins need syncing
#sed -i /etc/puppet/puppet.conf -e 's/\[main\]/\[main\]\npluginsync=true/'

service puppet restart

# CUMULUS-AUTOPROVISIONING

exit 0
