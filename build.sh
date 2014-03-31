#!/usr/bin/env bash

# clean up
rm -rf repo/*

# loop through repos
for R in `find pkgs/* -maxdepth 0 -type d`
do

    REPO=$(echo $R | sed -e "s/pkgs\///")

    # create empty repos
    mkdir -p repo/dists/cldemo/$REPO/binary-amd64
    mkdir -p repo/dists/cldemo/$REPO/binary-i386

    # loop through packages
    for P in `find pkgs/$REPO/* -maxdepth 0 -type d`
    do
        PKG=$(echo $P | sed -e "s/pkgs\/$REPO\///")
        dpkg-deb --build pkgs/$REPO/$PKG/debian repo/dists/cldemo/$REPO/binary-amd64/${PKG}_amd64.deb
    done

    # generate package lists
    dpkg-scanpackages -a amd64 repo/dists/cldemo/$REPO/binary-amd64 /dev/null | sed -e 's/Filename: repo\//Filename: /' > repo/dists/cldemo/$REPO/binary-amd64/Packages
    dpkg-scanpackages -a i386 repo/dists/cldemo/$REPO/binary-amd64 /dev/null | sed -e 's/Filename: repo\//Filename: /' > repo/dists/cldemo/$REPO/binary-i386/Packages


done

# upload
scp -r repo nat@dev.cumulusnetworks.com:public_html/cldemo/
