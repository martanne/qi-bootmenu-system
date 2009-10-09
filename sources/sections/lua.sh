setupfor lua 

# XXX: build shared lib

# disable readline dependency 
sed -i 's,^#define LUA_USE_READLINE,/* & */,g' src/luaconf.h

make CC="$CC" \
	AR="${CROSS}ar rcu" \
	RANLIB="${CROSS}ranlib" \
	INSTALL_ROOT="/usr" \
	MYCFLAGS="$CROSS_CFLAGS $CFLAGS" \
	MYLDFLAGS="$CROSS_LDFLAGS $LDFLAGS" \
	MYLIBS="-Wl,-E -ldl" \
	linux &&
make INSTALL_TOP="$STAGING_DIR/usr" install || dienow

cp etc/*.pc "$STAGING_DIR/usr/lib/pkgconfig"
#cp -P $STAGING_DIR/usr/lib/liblua.a $ROOT_DIR/usr/lib || dienow

pkgconfig_fixup_prefix lua

cleanup lua
