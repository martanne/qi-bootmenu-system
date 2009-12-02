setupfor tslib

[ ! -e ./configure ] && NOCONFIGURE=y ./autogen.sh

# 	--enable-linear-h2200  

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--enable-static \
	--disable-h3600 \
	--enable-input \
	--disable-corgi \
	--disable-collie \
	--disable-mk712 \
	--disable-arctic2 \
	--disable-ucb1x00 \
 	--disable-linear-h2200 &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

install_shared_library ts

pkgconfig_fixup_prefix ts
libtool_fixup_libdir ts

cleanup tslib
