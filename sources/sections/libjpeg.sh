setupfor libjpeg

./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

cp -P $STAGING_DIR/usr/lib/libjpeg.so* $ROOT_DIR/usr/lib || dienow

libtool_fixup_libdir libjpeg

cleanup libjpeg
