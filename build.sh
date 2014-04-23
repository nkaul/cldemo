#!/usr/bin/env bash

# clean up
if [ ! -e repo-build ]; then
    mkdir repo-build
else
    rm -rf repo-build/*
fi

# sync git submodules
git submodule init
git submodule update
# loop through repos
for R in `find pkgs/* -maxdepth 0 -type d`
do

    REPO=$(echo $R | sed -e "s/pkgs\///")

    # create empty repos
    mkdir -p repo-build/dists/cldemo/$REPO/binary-amd64
    mkdir -p repo-build/dists/cldemo/$REPO/binary-i386
    mkdir -p repo-build/dists/cldemo/$REPO/binary-powerpc

    # loop through packages
    for P in `find pkgs/$REPO/* -maxdepth 0 -type d`
    do
        PKG=$(echo $P | sed -e "s/pkgs\/$REPO\///")
        dpkg-deb --build pkgs/$REPO/$PKG/debian repo-build/dists/cldemo/$REPO/binary-amd64/${PKG}_amd64.deb
    done

    # generate package lists
    dpkg-scanpackages -a amd64 repo-build/dists/cldemo/$REPO/binary-amd64 /dev/null | sed -e 's/Filename: repo-build\//Filename: /' > repo-build/dists/cldemo/$REPO/binary-amd64/Packages
    dpkg-scanpackages -a i386 repo-build/dists/cldemo/$REPO/binary-amd64 /dev/null | sed -e 's/Filename: repo-build\//Filename: /' > repo-build/dists/cldemo/$REPO/binary-i386/Packages
    dpkg-scanpackages -a powerpc repo-build/dists/cldemo/$REPO/binary-powerpc /dev/null | sed -e 's/Filename: repo-build\//Filename: /' > repo-build/dists/cldemo/$REPO/binary-powerpc/Packages

done

# copy static content
cp -R repo-static/* repo-build/
