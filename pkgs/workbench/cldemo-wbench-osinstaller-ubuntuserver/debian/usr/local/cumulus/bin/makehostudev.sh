#!/usr/bin/env bash

#
# Copyright (C) 2014, Cumulus Networks www.cumulusnetworks.com
#
#

function udeventries  {
    SERVERNAME=$1
    INTCOUNT=`jq -r ".[] | .workbench.servers.$SERVERNAME.interfaces | length" /var/www/wbench.json`
    INTNUM=1
    while [ "$INTNUM" -le $INTCOUNT ]
    do
        let "INTIDX=INTNUM-1"
        INTPORT=`jq -r ".[] | .workbench.servers.$SERVERNAME.interfaces[$INTIDX].port" /var/www/wbench.json`
        INTMAC=`jq -r ".[] | .workbench.servers.$SERVERNAME.interfaces[$INTIDX].mac" /var/www/wbench.json`
        echo KERNEL==\"eth*\", ATTR{address}==\"$INTMAC\", NAME=\"$INTPORT\"
        let "INTNUM+=1"
    done
}

for SERVERNAME in $(jq -r '.[] | .workbench.servers[] | .["hostname"]' /var/www/wbench.json); do
    echo ""
    echo "if [ \"\$HOSTNAME\" = \"$SERVERNAME\" ]; then"
    echo "("
    echo "cat <<'EOF'"
    udeventries $SERVERNAME
    echo "EOF"
    echo ") > /etc/udev/rules.d/80-persistent-net.rules"
    echo "fi"
done


exit 0
