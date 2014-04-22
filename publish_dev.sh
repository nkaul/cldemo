#!/usr/bin/env bash

# upload
scp -r repo-build/* $USER@dev.cumulusnetworks.com:/home/devrepo/public_html/cldemo/repo/
