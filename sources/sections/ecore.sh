setupfor ecore

[ ! -e ./configure ] && NOCONFIGURE=y ./autogen.sh

# In theory we only need ecore-file. ecore-job, ecore-txt and ecore-evas
# however in practice ecore-evas seems to depend on on ecore-input and
# ecore-file seems to depend on ecore-con
# --with-iconv-link=-liconv \

LDFLAGS="$CROSS_LDFLAGS $LDFLAGS" CFLAGS="$CROSS_CFLAGS $CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--disable-simple-x11 \
	--disable-doc \
	--disable-ecore-x-xcb \
	--disable-atfile-source \
	--enable-ecore-con \
	--disable-ecore-config \
	--disable-ecore-ipc \
	--disable-abstract-sockets \
	--disable-curl \
	--disable-gnutls \
	--disable-openssl \
	--disable-poll \
	--disable-inotify \
	--disable-ecore-imf \
	--disable-ecore-imf_evas \
	--disable-ecore-evas-software-x11 \
	--disable-ecore-evas-opengl-x11 \
	--disable-ecore-evas-software-16-x11 \
	--disable-ecore-evas-xrender-xcb \
	--disable-ecore-evas-software-gdi \
	--disable-ecore-evas-software-ddraw \
	--disable-ecore-evas-direct3d \
	--disable-ecore-evas-opengl-glew \
	--disable-ecore-evas-software-16-ddraw \
	--disable-ecore-evas-quartz \
	--disable-ecore-evas-software-sdl \
	--disable-ecore-evas-directfb \
	--disable-ecore-evas-software-16-wince \
	--disable-ecore-x \
	--without-x \
	--enable-ecore-evas \
	--enable-ecore-evas-software-buffer \
	--enable-ecore-evas-fb \
	--enable-ecore-fb \
	--enable-ecore-job \
	--enable-ecore-txt \
	--enable-ecore-file && 
make &&
make DESTDIR="$STAGING_DIR" install || dienow

cp -P $STAGING_DIR/usr/lib/libecore*.so* $ROOT_DIR/usr/lib || dienow

pkgconfig_fixup_prefix ecore
libtool_fixup_libdir ecore

cleanup ecore
