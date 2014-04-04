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
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

email=jason@cumulusnetworks.com
account=Fidelity Demo
expires=1399100400 #2014-05-03
serial=QTFCA63420124
num_licenses=1
NFR=1
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJTPZH8AAoJEPxJF1FuRcN0IHgH+QH5l9OdsU8ZMa0pQaLqntj5
pS5LLqn9MJ9HfWK+pTwH8ayu/LvIXK5UNrp4ZGgE1Yycj7Y6LvLbxZaDQwy49FUP
QJUVyUUeNpBf9h0PDegDS/NPF0FHjdzi89jTWP8kSuSYeinShu/ZHLN06izLLuKf
uiDZyQ2hVq/RzNkt1RfvWHEEcVksxs8kRSvjqTGZUKofqwspfwy9DzVnaqZS2O0T
rQSIutb3gLKTtwro6hawI993BCHicuqTk+PoYQxU+oSp6CEa6hv8FAYF+QqMqay7
5tDK9C/i4cExI2oCqTrF7js34uscnVRVrr3Nksif7Xu3mUyjI5Ne3Okfx7/VOXk=
=7Kqp
-----END PGP SIGNATURE-----
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