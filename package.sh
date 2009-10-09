#!/bin/bash

source sources/include.sh || exit 1

cd $TOP && create_rootfs_tarball || dienow
