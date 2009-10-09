setupfor embryo

[ ! -e ./configure ] && NOCONFIGURE=y ./autogen.sh

./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--disable-doc &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

cp -P $STAGING_DIR/usr/lib/libembryo*.so* $ROOT_DIR/usr/lib || dienow

pkgconfig_fixup_prefix embryo
libtool_fixup_libdir embryo

cleanup embryo
