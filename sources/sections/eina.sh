setupfor eina

[ ! -e ./configure ] && NOCONFIGURE=y ./autogen.sh

#	--enable-default-mempool depends on pass-through
#	--disable-chained-pool con't be used because edje requires it

./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
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
	--enable-default-mempool &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

install_shared_library eina

pkgconfig_fixup_prefix eina
libtool_fixup_libdir eina

cleanup eina
