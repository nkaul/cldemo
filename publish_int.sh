#!/usr/bin/env bash

# make packages available internally (within MV)

# TODO check debs are built
# TODO check internal path exists / mount available

cp -r repo-build/dists/cldemo/* /mnt/repo/internal/dists/cldemo/

exit 0
