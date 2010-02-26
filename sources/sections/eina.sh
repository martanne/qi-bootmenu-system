setupfor eina

[ ! -e ./configure ] && NOCONFIGURE=y ./autogen.sh

[ ! -z "$QI_BOOTMENU_SHARED" ] && ENABLE="yes" || ENABLE="static"

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--disable-cpu-mmx \
	--disable-cpu-sse \
	--disable-cpu-sse2 \
	--disable-cpu-altivec \
	--disable-magic-debug \
	--disable-doc \
	--disable-pthread \
	--disable-tests \
	--disable-benchmark \
	--disable-fixed-bitmap \
	--disable-safety-checks \
	--disable-assert \
	--disable-chained-pool \
	--enable-pass-through=$ENABLE \
	--enable-default-mempool \
	--with-internal-maximum-log-level=0 &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

[ ! -z "$QI_BOOTMENU_SHARED" ] && install_shared_library eina

pkgconfig_fixup_prefix eina
libtool_fixup_libdir eina

cleanup eina
