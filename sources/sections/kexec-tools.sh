setupfor kexec-tools

[ ! -e ./configure ] && ./bootstrap

[ ! -z "$STATIC" ] && KEXEC_LDFLAGS="-static" 

LDFLAGS="$LDFLAGS $KEXEC_LDFLAGS " CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS \
	--prefix=/usr \
	--exec-prefix=/usr \
	--without-zlib &&
make &&

cp build/sbin/kexec "$ROOT_DIR/sbin" || dienow

cleanup kexec-tools
