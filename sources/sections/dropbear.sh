setupfor dropbear 

LDFLAGS="$LDFLAGS_EXE" CFLAGS="$CFLAGS_EXE" ./configure $CROSS_CONFIGURE_FLAGS --with-shared \
	--disable-zlib \
	--disable-pam \
	--enable-openpty \
	--disable-syslog \
	--disable-shadow \
	--disable-lastlog \
	--disable-utmp \
	--disable-utmpx \
	--disable-wtmp \
	--disable-wtmpx \
	--disable-loginfunc \
	--disable-pututline \
	--disable-pututxline

for c in \
	INETD_MODE \
	ENABLE_X11FWD \
	ENABLE_SVR_LOCALTCPFWD \
	ENABLE_SVR_REMOTETCPFWD \
	ENABLE_AGENTFWD \
	DROPBEAR_AES128 \
	DROPBEAR_AES256 \
	DROPBEAR_BLOWFISH \
	DROPBEAR_TWOFISH256 \
	DROPBEAR_TWOFISH128 \
	DROPBEAR_ENABLE_CTR_MODE \
	DROPBEAR_SHA1_96_HMAC \
	DROPBEAR_MD5_HMAC \
	DROPBEAR_DSS \
	DO_HOST_LOOKUP \
	DO_MOTD \
	ENABLE_SVR_PUBKEY_AUTH \
	SFTPSERVER_PATH
do
	sed -i 's,^#define '$c'.*,/* & */,g' options.h
done

make PROGRAMS="dropbear dropbearkey scp" MULTI=1

cp dropbearmulti "$ROOT_DIR/usr/sbin" || dienow
ln -sf dropbearmulti "$ROOT_DIR/usr/sbin/dropbear"
ln -sf dropbearmulti "$ROOT_DIR/usr/sbin/dropbearkey"
ln -sf ../sbin/dropbearmulti "$ROOT_DIR/usr/bin/scp"

cleanup dropbear
