#!/bin/bash

#CUMULUS-AUTOPROVISIONING

WEBSERVER="wbench.lab.local"
SSHKEYS="ansible/authorized_keys"
URL="http://${WEBSERVER}/${SSHKEYS}"
mkdir -p /root/.ssh
/usr/bin/wget -O /root/.ssh/authorized_keys $URL
exit 0
