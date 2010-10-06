#!/bin/bash

# Get lots of predefined environment variables and shell functions.

source sources/include.sh || exit 1

for tool in lzop dfu-util autoconf automake libtool gettext mkimage
do
  [ -z $(which "$tool") ] && echo "$tool not found in \$PATH" && exit 1
done

./download.sh || exit 1

if [ -z $(which "$CC") ]; then
  if [[ ! $(uname -m) == arm* ]]; then
    if [ ! -d "cross-compiler-$ARCH" ]; then
      tar xjf "$SRCDIR/cross-compiler-$ARCH.tar.bz2"
    fi
    export PATH="$PATH:$TOP/cross-compiler-$ARCH/bin"
  else
    echo "Compiler '$CC' not found in \$PATH." && exit 1
  fi
fi

echo "=== Building"

blank_tempdir "$WORK"

if [ $# -eq 0 ]
then
  rm -f "$TOP/initramfs-files"
  blank_tempdir "$STAGING_DIR"
  ln -s "usr/lib" "$STAGING_DIR/lib"
  blank_tempdir "$ROOT_DIR"
fi

if [[ ! -d "$ROOT_DIR" || ! -d "$ROOT_DIR/usr" ]]
then
  mkdir -p "$ROOT_DIR"/{tmp,proc,sys,dev,mnt,home/root} || dienow
  for i in bin sbin lib etc
  do
    mkdir -p "$ROOT_DIR/usr/$i" || dienow
    ln -s "usr/$i" "$ROOT_DIR/$i" || dienow
  done
fi

if [ $# -ne 0 ] 
then
  for arg in "$@"
  do
    build_package "$arg" 
  done
  exit
fi

# build initramfs content

build_package linux-headers
build_package uClibc
build_package busybox
build_package kexec-tools
build_package zlib
build_package libpng
build_package tslib
build_package freetype
build_package eina
build_package evas
build_package ecore
build_package qi-bootmenu
build_package dropbear

# copy the the root-overlay drectory over the initramfs and generate
# a file called 'initramfs-files' which can be specified as
# CONFIG_INITRAMFS_SOURCE during the kernel build

cd "$TOP" && ./initramfs.sh

# build kernel which embedds the previously built initramfs content

build_package kernel
build_package qi
