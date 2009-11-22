#!/bin/bash

# Architecture

ARCH=armv4tl
KARCH=arm
ARCH_NAME="$ARCH"
STAGE_NAME="native"

# Directory layout
TOP=`pwd`
export SOURCES="${TOP}/sources"
export SCRIPTS="${SOURCES}/scripts"
export SRCDIR="${TOP}/packages"
export ROOT_DIR="${TOP}/rootfs"
export ROOT_OVERLAY="${TOP}/rootfs-overlay"
export BUILD="${TOP}/build"
export CONFIG_DIR="${TOP}/sources/configs"
export WORK="${BUILD}/temp-${ARCH}"
export STAGING_DIR="${TOP}/staging-dir"

# Default flags to point the compiler to the right libraries and
# include files. In the case of cross compiling this assumes that
# the compiler doesn't add system directories to it's search paths.
# This is taken care of by a gcc wrapper script which passes things 
# like -nostdinc -nostdlibs -nodefaultlibs to gcc. 

CFLAGS_HEADERS="-I$STAGING_DIR/usr/include"

if [ -z "$DEBUG" ]; then
  CFLAGS="$CFLAGS_HEADERS -Os -pipe -march=armv4t -mtune=arm920t"
else
  CFLAGS="$CFLAGS_HEADERS -O0 -g -ggdb -pipe -march=armv4t -mtune=arm920t"
fi

LDFLAGS_LIBS="-L$STAGING_DIR/usr/lib"
LDFLAGS="$LDFLAGS_LIBS"

# Make sure that pkg-config uses the right paths and doesn't pull
# in depencies from the host system.
export PKG_CONFIG_PATH="${STAGING_DIR}/usr/lib/pkgconfig"
export PKG_CONFIG_LIBDIR="${STAGING_DIR}/usr/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="${STAGING_DIR}"

# check if we are building natively or if we are cross compiling

if [[ ! $(uname -m) == arm* ]]
then
  STAGE_NAME="cross"
  CROSS_CONFIGURE_FLAGS="--build=`$SCRIPTS/config.guess` \
	--target=armv4tl-unknown-linux-gnueabi \
	--host=armv4tl-unknown-linux-gnueabi"
  # cross compiler prefix used by kernel, uclibc and busybox 
  # build system
  [ -z "$CROSS" ] && CROSS="armv4tl-"
fi

STRIP="${CROSS}strip"
[ -z "$CC" ] && export CC="${CROSS}gcc"

umask 022

# Tell bash not to cache the $PATH because we modify it.  Without 
# this, bash won't find new executables added after startup.
set +h

[ -e config ] && source config
source sources/functions-fwl.sh
source sources/functions.sh

# How many processors should make -j use?

if [ -z "$CPUS" ]
then
  export CPUS=$(echo /sys/devices/system/cpu/cpu[0-9]* | wc -w)
  [ "$CPUS" -lt 1 ] && CPUS=1
fi

export MAKEFLAGS="-j $CPUS"

# This is an if instead of && so the exit code of include.sh is reliably 0
if [ ! -z "$BUILD_VERBOSE" ]
then
  VERBOSITY="V=1"
fi
