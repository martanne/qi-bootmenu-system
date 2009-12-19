setupfor kexec-tools

[ ! -e ./configure ] && ./bootstrap

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--exec-prefix=/usr &&
make &&

cp build/sbin/kexec "$ROOT_DIR/sbin" || dienow

cleanup kexec-tools
