#!/bin/sh

setupfor strace

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

cp -P $STAGING_DIR/usr/bin/strace* $ROOT_DIR/usr/bin || dienow

cleanup strace
