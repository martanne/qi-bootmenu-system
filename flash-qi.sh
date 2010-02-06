#!/bin/sh

. ./config

case "$MACHINE" in
  GTA01)
    CPU="s3c2410"
    DEV="0x1457:0x5119"
    ;;
  *)
    CPU="s3c2442"
    DEV="0x1d50:0x5119"
    ;;
esac

dfu-util -a 1 -d $DEV -D qi-$CPU*.udfu
