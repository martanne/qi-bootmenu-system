#!/bin/bash

# Get lots of predefined environment variables and shell functions.

source sources/include.sh || exit 1

./download.sh || exit 1

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

build_package linux-headers
build_package uClibc
build_package busybox
build_package kexec-tools
build_package zlib
build_package libjpeg
build_package tslib
build_package freetype
build_package eina
build_package eet
build_package evas
build_package ecore
build_package embryo
build_package lua
build_package edje
build_package elementary
build_package dropbear
build_package dialog-elementary

echo "Build complete now run ./initramfs.sh"
