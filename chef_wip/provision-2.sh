#!/usr/bin/env bash
cd /home/cumulus

clear
echo "Install chef server\n\n"

wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.11-1.ubuntu.12.04_amd64.deb

sudo dpkg -i ./chef-server_11.0.11-1.ubuntu.12.04_amd64.deb

sudo chef-server-ctl reconfigure

sudo sed -i /var/opt/chef-server/nginx/etc/nginx.conf -e 's/listen 80/listen 8002/'

sudo chef-server-ctl restart

clear
echo "Install chef workstation\n\n"
sudo apt-get install curl

sudo curl -L https://www.opscode.com/chef/install.sh | sudo bash

clear
echo "Setup chef repo\n\n"
cp -r /home/cumulus/cldemo/chef_wip/chef-repo /home/cumulus

mkdir /home/cumulus/chef_repo/.chef

clear
echo "Get admin and chef-validator private keys\n\n"
sudo cp /etc/chef-server/admin.pem /home/cumulus/chef-repo/.chef/admin.pem
sudo cp /etc/chef-server/chef-validator.pem /home/cumulus/chef-repo/.chef/chef-validator.pem

sudo chown cumulus /home/cumulus/chef-repo/.chef/admin.pem
sudo chgrp cumulus /home/cumulus/chef-repo/.chef/admin.pem
sudo chown cumulus  /home/cumulus/chef-repo/.chef/chef-validator.pem
sudo chgrp cumulus  /home/cumulus/chef-repo/.chef/chef-validator.pem

cd /home/cumulus/chef-repo

clear 
echo "Configure knife initial. Will create /home/cumulus/chef-repo/.chef/knife.rb\n"
echo "values for prompts: 1. URL: <select default>\n 2. new user: <select default>\n 3. admin name: <select default>\n 4.location of admin's private key: /home/cumulus/chef-repo/.chef/admin.pem\n 5. validation clientname: <select default>\n 6. Location of validation key: /home/cumulus/chef-repo/.chef/chef-validator.pem\n 7. path to chef repository: /home/cumulus/chef-repo\n\n"

knife configure --initial

clear
echo "Bootstrap nodes, when prompted for password, enter CumulusLinux!\n\n"
cd /home/cumulus/chef-repo
knife bootstrap leaf1 -x cumulus -P CumulusLinux! -N leaf1 --sudo
knife bootstrap leaf2 -x cumulus -P CumulusLinux! -N leaf2 --sudo
knife bootstrap spine1 -x cumulus -P CumulusLinux! -N spine1 --sudo
knife bootstrap spine2 -x cumulus -P CumulusLinux! -N spine2 --sudo

clear
echo "Create data bags, upload cookbooks, set run lists\n\n"
knife upload cookbooks
knife data bag create topo
knife data bag from file topo topo.json

knife node run_list add leaf1 ospf-unnumbered
knife node run_list add leaf2 ospf-unnumbered
knife node run_list add spine1 ospf-unnumbered
knife node run_list add spine2 ospf-unnumbered

exit 0
