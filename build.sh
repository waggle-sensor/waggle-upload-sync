#!/bin/bash -e

docker run --rm \
  -e NAME="waggle-upload-sync" \
  -e DESCRIPTION="Waggle Upload Sync Service" \
  -e "MAINTAINER=sagecontinuum.org" \
  -v "$PWD:/repo" \
  waggle/waggle-deb-builder:0.2.0
