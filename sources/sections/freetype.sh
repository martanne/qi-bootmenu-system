setupfor freetype

cp "$CONFIG_DIR/freetype-modules.cfg" modules.cfg

./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

cp -P $STAGING_DIR/usr/lib/libfreetype.so* $ROOT_DIR/usr/lib || dienow

pkgconfig_fixup_prefix freetype 
libtool_fixup_libdir freetype

cleanup freetype
