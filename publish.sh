#!/usr/bin/env bash

#--------------------------------------------------------------------------
#
# Copyright 2014 Cumulus Networks, inc  all rights reserved
#
#--------------------------------------------------------------------------

# available repos
repos=( stable testing )

# check params
while getopts "r:" opt; do
    case "$opt" in
        r) repo=$OPTARG ;;
    esac
done
shift $(( OPTIND - 1))

# confirm repo specified and known
if [[ -z "$repo" ]]; then
    echo "ERROR: Repo not specified"
    exit 1
else
    # check repo is in list
    REPOOK=0
    for i in "${repos[@]}"
    do
        if [ "$i" == "$repo" ] ; then
            REPOOK=1
        fi
    done
    if [ $REPOOK -eq 0 ]; then
        echo "ERROR: Repo '$repo' not known"
        exit 1
    fi
fi

# current branch
BRANCH=`git rev-parse --abbrev-ref HEAD`
if [ "$repo" == "stable" ] && [ "$BRANCH" != "master" ]; then
    echo "ERROR: Trying to publish non-master branch '$BRANCH' to stable"
    exit 1
fi

# upload
scp -r repo-build/* cldemo@repo-publish:/opt/cldemo/$repo/dists/cldemo

exit 0
