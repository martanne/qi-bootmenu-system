setupfor tslib

[ ! -e ./configure ] && ./autogen.sh

[ -z "$STATIC" ] && ENABLE="yes" || ENABLE="static"

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--enable-static \
	--enable-pthres=$ENABLE \
	--enable-variance=$ENABLE \
	--enable-dejitter=$ENABLE \
	--enable-linear=$ENABLE \
	--enable-input=$ENABLE \
	--disable-h3600 \
	--disable-corgi \
	--disable-collie \
	--disable-mk712 \
	--disable-arctic2 \
	--disable-tatung \
	--disable-ucb1x00 \
 	--disable-linear-h2200 &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

[ -z "$STATIC" ] && install_shared_library ts

pkgconfig_fixup_prefix ts
libtool_fixup_libdir ts

cleanup tslib
