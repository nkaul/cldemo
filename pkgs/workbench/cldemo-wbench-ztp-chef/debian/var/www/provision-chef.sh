#!/bin/bash

# Allow Cumulus testing repo
#sed -i /etc/apt/sources.list -e 's/# deb http:\/\/repo.cumulusnetworks.com CumulusLinux-2.1 testing/deb http:\/\/repo.cumulusnetworks.com CumulusLinux-2.1 testing/'

# Upgrade and install Chef
apt-get update -y
apt-get upgrade -y

apt-get install curl chef -y

echo "Configuring Chef" | wall -n

[[ -d /etc/chef ]] || mkdir /etc/chef

omask=$(umask)

umask 0077
curl http://192.168.0.1/chef-validator.pem >/etc/chef/validation.pem || echo "Failed to download validation certificate"
umask $omask

if [[ ! -f /etc/chef/client.rb ]]; then
  cat <<EOF >/etc/chef/client.rb
  log_level :info
  log_location STDOUT
  chef_server_url 'https://wbench.lab.local:443/'
  validation_client_name 'chef-validator'
  interval 300
EOF
fi

chef-client -o "recipe[cldemo_base::chef-client]" --once

# CUMULUS-AUTOPROVISIONING

exit 0
