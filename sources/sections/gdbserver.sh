setupfor gdb

cd gdb/gdbserver || dienow

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--program-prefix="" &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

cp "$STAGING_DIR/usr/bin/gdbserver" "$ROOT_DIR/usr/bin" || dienow

cleanup gdb
