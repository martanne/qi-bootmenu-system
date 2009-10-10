#!/bin/bash

# Get lots of predefined environment variables and shell functions.

source sources/include.sh || exit 1

./download.sh || exit 1

if [ -z "$CC" ]; then
  if [ -z "$CROSS" ]; then
    export CC="gcc"
  else
    export CC="${CROSS}gcc"
  fi
fi

[ -z $(which "$CC") ] && echo "Compiler '$CC' not found in \$PATH." && exit 1 

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
  mkdir -p "$ROOT_DIR"/{tmp,proc,sys,dev,home/root} || dienow
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
    build_section "$arg" 
  done
  exit
fi

build_section linux-headers
build_section uClibc
build_section busybox
build_section kexec-tools
build_section zlib
build_section libjpeg
build_section tslib
build_section freetype
build_section eina
build_section eet
build_section evas
build_section ecore
build_section embryo
build_section lua
build_section edje
build_section elementary
build_section dropbear
build_section dialog-elementary

echo "Build complete now run ./initramfs.sh"
