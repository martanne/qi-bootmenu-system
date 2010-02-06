#!/bin/sh

source ./config

[ -z "$MACHINE" ] && MACHINE="GTA02"

case "$MACHINE" in
  GTA01)
    DEV="0x1457:0x5119"
    ;;
  *)
    DEV="0x1d50:0x5119"
    ;;
esac

dfu-util --device $DEV -a kernel -R -D uImage-$MACHINE.bin
