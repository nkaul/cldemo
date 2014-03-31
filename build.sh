#!/usr/bin/env bash

# clean up
rm -rf repo/*
mkdir -p repo/dists/cldemo/workbench/binary-amd64
mkdir -p repo/dists/cldemo/workbench/binary-i386
mkdir -p repo/dists/cldemo/switch/binary-amd64
mkdir -p repo/dists/cldemo/switch/binary-i386

# build debs
for D in `find pkgs/workbench/* -maxdepth 0 -type d`
do
    PKG=$(echo $D | sed -e "s/pkgs\/workbench\///")
    echo $PKG
    dpkg-deb --build pkgs/workbench/$PKG/debian repo/dists/cldemo/workbench/binary-amd64/${PKG}_amd64.deb
done

# create repo
dpkg-scanpackages -a amd64 repo/dists/cldemo/workbench/binary-amd64 /dev/null | sed -e 's/Filename: repo\//Filename: /' > repo/dists/cldemo/workbench/binary-amd64/Packages
dpkg-scanpackages -a i386 repo/dists/cldemo/workbench/binary-amd64 /dev/null | sed -e 's/Filename: repo\//Filename: /' > repo/dists/cldemo/workbench/binary-i386/Packages

# upload
scp -r repo nat@dev.cumulusnetworks.com:public_html/cldemo/
