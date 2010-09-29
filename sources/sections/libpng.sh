setupfor libpng

# --without-libpng-compat ?
# --with-zlib=$ROOT_DIR/usr doesn't seem to work
LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--without-libpng-compat &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

if [ ! -z "$QI_BOOTMENU_SHARED" ]; then
  cp -P $STAGING_DIR/usr/lib/libpng*.so* $ROOT_DIR/usr/lib || dienow
fi

libtool_fixup_libdir libpng

cleanup libpng
