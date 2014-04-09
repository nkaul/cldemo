#!/usr/bin/env bash
cd /home/cumulus

clear
printf "Install chef server\n\n"

wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.11-1.ubuntu.12.04_amd64.deb

sudo dpkg -i ./chef-server_11.0.11-1.ubuntu.12.04_amd64.deb

sudo chef-server-ctl reconfigure

sudo sed -i /var/opt/chef-server/nginx/etc/nginx.conf -e 's/listen 80/listen 8002/'

sudo chef-server-ctl restart

clear
printf "Install chef workstation\n\n"
sudo apt-get install curl

sudo curl -L https://www.opscode.com/chef/install.sh | sudo bash

clear
printf "Setup chef repo\n\n"
cp -r /home/cumulus/cldemo/chef_wip/chef-repo /home/cumulus

mkdir /home/cumulus/chef-repo/.chef

clear
printf "Get admin and chef-validator private keys\n\n"
sudo cp /etc/chef-server/admin.pem /home/cumulus/chef-repo/.chef/admin.pem
sudo cp /etc/chef-server/chef-validator.pem /home/cumulus/chef-repo/.chef/chef-validator.pem

sudo chown cumulus /home/cumulus/chef-repo/.chef/admin.pem
sudo chgrp cumulus /home/cumulus/chef-repo/.chef/admin.pem
sudo chown cumulus  /home/cumulus/chef-repo/.chef/chef-validator.pem
sudo chgrp cumulus  /home/cumulus/chef-repo/.chef/chef-validator.pem

cd /home/cumulus/chef-repo

clear 
printf "Configure knife initial. \nWill create /home/cumulus/chef-repo/.chef/knife.rb\n"
printf "values for prompts: \n1. Where to put knife.rb: /home/cumulus/chef-repo/.chef/knife.rb\n 2. URL: <select default>\n 3. new user: <select default>\n 4. admin name: <select default>\n 5.location of admin's private key: /home/cumulus/chef-repo/.chef/admin.pem\n 6. validation clientname: <select default>\n 7. Location of validation key: /home/cumulus/chef-repo/.chef/chef-validator.pem\n 8. path to chef repository: /home/cumulus/chef-repo\n9. Password for new user: abc1234\n\n"

knife configure --initial

clear
printf "Bootstrap nodes\n\n"
cd /home/cumulus/chef-repo
#knife bootstrap leaf1 -x cumulus -P CumulusLinux! -N leaf1 --sudo
#knife bootstrap leaf2 -x cumulus -P CumulusLinux! -N leaf2 --sudo
#knife bootstrap spine1 -x cumulus -P CumulusLinux! -N spine1 --sudo
#knife bootstrap spine2 -x cumulus -P CumulusLinux! -N spine2 --sudo
knife bootstrap leaf1 -x root -P CumulusLinux! -N leaf1 
knife bootstrap leaf2 -x root -P CumulusLinux! -N leaf2
knife bootstrap spine1 -x root -P CumulusLinux! -N spine1
knife bootstrap spine2 -x root -P CumulusLinux! -N spine2

clear
printf "Create data bags, upload cookbooks, set run lists\n\n"
knife upload cookbooks
knife data bag create topo
knife data bag from file topo topo.json

#knife node run_list add leaf1 apt
#knife node run_list add leaf2 apt
#knife node run_list add spine1 apt
#knife node run_list add spine2 apt

knife node run_list add leaf1 ospf-unnumbered
knife node run_list add leaf2 ospf-unnumbered
knife node run_list add spine1 ospf-unnumbered
knife node run_list add spine2 ospf-unnumbered

clear
printf "\nSince this is free version of Chef Server, push functionality is not available. You can login to individual switch and execute 'chef-client' to pull the configuration.\nAlternatively execute the command \n   'ansible switches -m shell -a \"chef-client\" -u root -f 4' \n to execute the command 'chef-client' on all the switches from here.\n"
exit 0
