#!/bin/bash

function error() {
  echo -e "\e[0;33mERROR: Provisioning failed running $BASH_COMMAND at line $BASH_LINENO of $(basename $0) \e[0m" >&2
  exit 1
}

trap error ERR

echo "Adding users" | wall -n
#adding users rocket and turtle with password lettuce
useradd rocket -g cumulus -G sudo -m -s /bin/bash -d /home/rocket -p '$1$rA6KCeAS$QBfUBCwU19cueiECo3pOg1'
useradd turtle -g cumulus -G sudo -m -s /bin/bash -d /home/turtle -p '$1$rA6KCeAS$QBfUBCwU19cueiECo3pOg1'

echo "Updating MOTD" | wall -n

echo "`hostname` configured by bash ZTP" > /etc/motd
# CUMULUS-AUTOPROVISIONING

exit 0
