#!/bin/bash

function error() {
  echo -e "\e[0;33mERROR: Provisioning failed running $BASH_COMMAND at line $BASH_LINENO of $(basename $0) \e[0m" >&2
  exit 1
}

trap error ERR

URL="http://wbench.lab.local/ansible_authorized_keys"

mkdir -p /root/.ssh

/usr/bin/wget -O /root/.ssh/authorized_keys $URL

#CUMULUS-AUTOPROVISIONING

exit 0
