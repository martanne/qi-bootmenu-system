setupfor libjpeg

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

if [ ! -z "$QI_BOOTMENU_SHARED" ]; then
  cp -P $STAGING_DIR/usr/lib/libjpeg.so* $ROOT_DIR/usr/lib || dienow
fi

libtool_fixup_libdir libjpeg

cleanup libjpeg
