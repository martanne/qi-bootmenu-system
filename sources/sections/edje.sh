setupfor edje

[ ! -e ./configure ] && NOCONFIGURE=y ./autogen.sh

# XXX: we don't need edje_cc in cross compilation mode 

LDFLAGS="$CROSS_LDFLAGS $LDFLAGS" CFLAGS="$CROSS_CFLAGS $CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--disable-edje-cc \
	--disable-doc &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

cp -P $STAGING_DIR/usr/lib/libedje*.so* $ROOT_DIR/usr/lib || dienow

pkgconfig_fixup_prefix edje
libtool_fixup_libdir edje

cleanup edje
