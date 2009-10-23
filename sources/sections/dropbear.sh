setupfor dropbear 

LDFLAGS="$CROSS_LDFLAGS $LDFLAGS" CFLAGS="$CROSS_CFLAGS $CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --with-shared \
	--disable-pam \
	--enable-openpty \
	--enable-syslog \
	--disable-shadow \
	--disable-lastlog \
	--disable-utmp \
	--disable-utmpx \
	--disable-wtmp \
	--disable-wtmpx \
	--disable-loginfunc \
	--disable-pututline \
	--disable-pututxline

for c in INETD_MODE ENABLE_X11FWD DROPBEAR_BLOWFISH DROPBEAR_TWOFISH256 \
		DROPBEAR_TWOFISH128 DROPBEAR_MD5_HMAC DO_MOTD DO_HOST_LOOKUP
do
	sed -i 's,^#define '$c',/* & */,g' options.h
done

make PROGRAMS="dropbear dropbearkey scp" MULTI=1

cp dropbearmulti "$ROOT_DIR/usr/sbin" || dienow
ln -sf dropbearmulti "$ROOT_DIR/usr/sbin/dropbear"
ln -sf dropbearmulti "$ROOT_DIR/usr/sbin/dropbearkey"
ln -sf ../sbin/dropbearmulti "$ROOT_DIR/usr/bin/scp"

cleanup dropbear
