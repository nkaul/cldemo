#!/usr/bin/env bash

# TODO check debs are built

# upload
scp -r repo-build/* $USER@dev.cumulusnetworks.com:/home/devrepo/public_html/cldemo/repo/

exit 0
