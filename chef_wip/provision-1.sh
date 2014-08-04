#!/usr/bin/env bash
cd /home/cumulus

echo ""
echo "Generate ssh keys"
ssh-keygen

clear
echo ""
echo "Install Ansible..."
git clone https://github.com/ansible/ansible.git
cd /home/cumulus/ansible
sudo make install
sudo apt-get -y install python-dev libyaml-dev sshpass
sudo pip install pyyaml
sudo pip install jinja2

clear
echo ""
echo "Setup /etc/ansible/hosts file..."
sudo mkdir -p /etc/ansible
sudo bash -c "cat << EOF >/etc/ansible/hosts 
[switches]
leaf1
leaf2
spine1
spine2
EOF
"

sudo bash -c "cat << EOF >/etc/ansible/ansible.cfg
[defaults]
host_key_checking = False
EOF
"

sudo bash -c "cat << EOF >/home/cumulus/lic
# License goes here
EOF
"


clear
echo ""
echo "Ansible - Push ssh key to root @ switches...."
echo ""
echo "Please input password for switch at the prompt (CumulusLinux!)"
ansible switches -m authorized_key -a "key='{{ lookup('file', '/home/cumulus/.ssh/id_rsa.pub') }}' user=root" --sudo --ask-sudo-pass -k

echo ""
echo "Setup ZTP provisioning..."
sudo sed -i /etc/dhcp/dhcpd.pools -e 's/# option cumulus-provision-url/option cumulus-provision-url/'
sudo service isc-dhcp-server restart

sudo bash -c "cat << EOF > /var/www/provision.sh
#!/bin/bash
# CUMULUS-AUTOPROVISIONING
apt-get install chef
EOF
"

echo ""
echo "Ansible - Push license to all switches.."
ansible switches -m shell -a "mkdir -p /mnt/persist/etc/cumulus" -u root
ansible switches -m copy -a "src=/home/cumulus/lic dest=/mnt/persist/etc/cumulus/.license.txt" -u root
ansible switches -m copy -a "src=/home/cumulus/lic dest=/etc/cumulus/.license.txt" -u root

echo ""
echo "Ansible - Reboot the switches, ZTP will install chef on the switches"
ansible switches -a "/sbin/reboot" -u root

echo ""
echo "ZTP install of chef takes atleast 5 minutes. Wait for 10 minutes before running Chef provisioning script"

exit 0
