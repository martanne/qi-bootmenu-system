setupfor libiconv 

# we don't want and have wchar_t support in uclibc but some include
# file of gcc seems to pull it in

./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--enable-static \
	--enable-relocatable \
	--disable-rpath \
	--disable-nls &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow


cp -P $STAGING_DIR/usr/lib/libcharset.so* $ROOT_DIR/usr/lib || dienow
cp -P $STAGING_DIR/usr/lib/libiconv.so* $ROOT_DIR/usr/lib || dienow

libtool_fixup_libdir libiconv
libtool_fixup_libdir libcharset

cleanup libiconv 
