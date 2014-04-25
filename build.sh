#!/usr/bin/env bash

# check pre-reqs
TOOLMISSING=0
tools=(dpkg-deb dpkg-scanpackages)
for TOOL in ${tools[@]}; do
    if ! hash $TOOL 2>/dev/null; then
       echo "** ERROR ** $TOOL not installed"
       TOOLMISSING=$[$TOOLMISSING +1]
    fi
done
if [[ $TOOLMISSING -gt 0 ]]
then
    echo "$TOOLMISSING tools/cmds missing"
    exit 1
fi

# clean up
if [ ! -e repo-build ]; then
    mkdir repo-build
else
    rm -rf repo-build/*
fi

# sync git submodules
git submodule init
git submodule update

architectures=(amd64 i386 powerpc)

# loop through repos
for R in `find pkgs/* -maxdepth 0 -type d`
do

    REPO=$(echo $R | sed -e "s/pkgs\///")

    echo ""
    echo "$REPO repo..."
    echo ""

    # create empty repos
    for ARCH in ${architectures[@]}; do
        mkdir -p repo-build/dists/cldemo/$REPO/binary-$ARCH
    done

    # loop through packages
    for P in `find pkgs/$REPO/* -maxdepth 0 -type d`
    do
        PKG=$(echo $P | sed -e "s/pkgs\/$REPO\///")
        if ! dpkg-deb --build pkgs/$REPO/$PKG/debian repo-build/dists/cldemo/$REPO/binary-amd64/${PKG}_amd64.deb
	then
	    echo "** ERROR ** while building $REPO/$PKG"
	    exit 1
	fi
    done

    # generate package lists
    for ARCH in ${architectures[@]}; do
        if ! dpkg-scanpackages -a $ARCH repo-build/dists/cldemo/$REPO/binary-$ARCH /dev/null | sed -e 's/Filename: repo-build\//Filename: /' > repo-build/dists/cldemo/$REPO/binary-$ARCH/Packages
        then
            echo "** ERROR ** while generating repo for  $REPO $ARCH"
            exit 1
        fi
    done

done

# copy static content
cp -R repo-static/* repo-build/

echo ""
echo "Done"
echo ""

exit 0
