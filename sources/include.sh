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
export CONFIG_DIR="${TOP}/sources"
export WORK="${BUILD}/temp-${ARCH}"
export STAGING_DIR="${TOP}/staging-dir"

# Default flags to point the compiler to the right libraries and
# include files. In the case of cross compiling this assumes that
# the compiler doesn't add system directories to it's search paths.
# This is taken care of by a gcc wrapper script which passes things 
# like -nostdinc -nostdlibs -nodefaultlibs to gcc. 

CFLAGS_HEADERS="-I$STAGING_DIR/usr/include" 
CFLAGS="$CFLAGS_HEADERS -Os -pipe -march=armv4t -mtune=arm9tdmi"
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
  CROSS_LDFLAGS=
  CROSS_CFLAGS=
  # XXX: --build=`config.guess`
  CROSS_CONFIGURE_FLAGS="--build=i686-pc-linux-gnu \
	--target=armv4tl-unknown-linux-gnueabi \
	--host=armv4tl-unknown-linux-gnueabi"
  # cross compiler prefix used by kernel, uclibc and busybox 
  # build system
  export CROSS="armv4tl-unknown-linux-gnueabi-"
fi

STRIP="${CROSS}strip"

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

# This is an if instead of && so the exit code of include.sh is reliably 0
if [ ! -z "$BUILD_VERBOSE" ]
then
  VERBOSITY="V=1"
fi
