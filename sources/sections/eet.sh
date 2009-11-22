setupfor eet 

[ ! -e ./configure ] && NOCONFIGURE=y ./autogen.sh

# depends on: zlib libjpepg

# XXX: if we have run autogen libtool for some reasons
#      has the variable link_all_deplibs set to no and 
#      therefore doesn't link against dependency libs 
#
#      for now we change the libtool variable with sed 

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--disable-openssl \
	--disable-gnutls \
	--disable-cipher \
	--disable-signature \
	--disable-doc \
	--disable-old-eet-file-format &&
sed -i 's/^link_all_deplibs=no$/link_all_deplibs=unknown/g' libtool
make &&
make DESTDIR="$STAGING_DIR" install || dienow

cp -P $STAGING_DIR/usr/lib/libeet.so* $ROOT_DIR/usr/lib || dienow

pkgconfig_fixup_prefix eet
libtool_fixup_libdir eet

cleanup eet
