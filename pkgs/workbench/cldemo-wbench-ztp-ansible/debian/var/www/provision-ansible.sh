#!/bin/bash

URL="http://wbench.lab.local/ansible_authorized_keys"

mkdir -p /root/.ssh

/usr/bin/wget -O /root/.ssh/authorized_keys $URL

#CUMULUS-AUTOPROVISIONING

exit 0
