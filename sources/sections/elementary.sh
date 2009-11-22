setupfor elementary

[ ! -e ./configure ] && NOCONFIGURE=y ./autogen.sh

# use host edje_cc

# XXX: if we have run autogen libtool for some reasons
#      has the variable link_all_deplibs set to no and 
#      therefore doesn't link against dependency libs 
#
#      for now we change the libtool variable with sed 

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--with-edje-cc=edje_cc &&
sed -i 's/^link_all_deplibs=no$/link_all_deplibs=unknown/g' libtool
make && 
make DESTDIR="$STAGING_DIR" install || dienow

cp -P $STAGING_DIR/usr/lib/libelementary*.so* $ROOT_DIR/usr/lib || dienow
mkdir -p $ROOT_DIR/usr/share/elementary/themes && 
cp -P $STAGING_DIR/usr/share/elementary/themes/*.edj $ROOT_DIR/usr/share/elementary/themes || dienow

pkgconfig_fixup_prefix elementary
libtool_fixup_libdir elementary

cleanup elementary
