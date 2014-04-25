#!/usr/bin/env bash

# make packages available externally

# check running on frank-02
if [[ `hostname -s` != "frank-02" ]]; then
    echo "** ERROR ** must be run frank-02"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo "** ERROR ** This script must be run as root"
   exit 1
fi

echo "Copying packages from internal to live repo"
rsync  -avz --delete /mnt/repo/internal/dists/cldemo root@ec2-23-22-88-32.compute-1.amazonaws.com:/mnt/repo/repo/dists

exit 0
