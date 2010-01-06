setupfor freetype

cp "$CONFIG_DIR/freetype-modules.cfg" modules.cfg

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

if [ -z "$STATIC" ]; then
  cp -P $STAGING_DIR/usr/lib/libfreetype.so* $ROOT_DIR/usr/lib || dienow
fi

pkgconfig_fixup_prefix freetype 
libtool_fixup_libdir freetype

cleanup freetype
