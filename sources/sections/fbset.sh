#!/bin/sh

setupfor fbset

make CC="$CC" LDFLAGS="$CROSS_LDFLAGS $LDFLAGS" CFLAGS="$CROSS_CFLAGS $CFLAGS" || dienow

cp fbset $ROOT_DIR/usr/bin || dienow

cleanup fbset
