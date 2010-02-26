setupfor evas

[ ! -e ./configure ] && NOCONFIGURE=y ./autogen.sh

[ ! -z "$QI_BOOTMENU_SHARED" ] && ENABLE="yes" || ENABLE="static"

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--enable-fb=$ENABLE \
	--disable-directfb \
	--disable-sdl \
	--enable-buffer=$ENABLE	\
	--disable-evas-cserve \
	--enable-static-software-generic \
	--disable-software-ddraw \
	--disable-software-qtopia \
	--disable-software-xlib	\
	--disable-software-16-x11 \
	--disable-software-xcb \
	--disable-gl-x11 \
	--disable-xrender-x11 \
	--disable-xrender-xcb \
	--disable-glitz-x11 \
	--disable-image-loader-eet \
	--disable-image-loader-edb \
	--disable-image-loader-gif \
	--enable-image-loader-png=$ENABLE \
	--disable-image-loader-pmaps \
	--disable-image-loader-jpeg \
	--disable-image-loader-tiff \
	--disable-image-loader-xpm \
	--disable-image-loader-svg \
	--enable-cpu-c \
	--disable-evas-magic-debug \
	--disable-fontconfig \
	--disable-font-loader-eet \
	--disable-scale-sample \
	--enable-scale-smooth \
	--enable-convert-yuv \
	--enable-small-dither-mask \
	--disable-no-dither-mask \
	--disable-convert-8-rgb-332 \
	--disable-convert-8-rgb-666 \
	--disable-convert-8-rgb-232 \
	--disable-convert-8-rgb-222 \
	--disable-convert-8-rgb-221 \
	--disable-convert-8-rgb-121 \
	--disable-convert-8-rgb-111 \
	--enable-convert-16-rgb-565 \
	--disable-convert-16-rgb-555 \
	--disable-convert-16-rgb-444 \
	--disable-convert-16-rgb-ipq \
	--enable-convert-16-rgb-rot-0 \
	--enable-convert-16-rgb-rot-90 \
	--disable-convert-16-rgb-rot-180 \
	--enable-convert-16-rgb-rot-270 \
	--enable-convert-24-rgb-888 \
	--enable-convert-24-bgr-888 \
	--enable-convert-32-rgb-8888 \
	--enable-convert-32-rgbx-8888 \
	--enable-convert-32-bgr-8888 \
	--enable-convert-32-bgrx-8888 \
	--enable-convert-32-rgb-rot-0 \
	--enable-convert-32-rgb-rot-90 \
	--disable-convert-32-rgb-rot-180 \
	--enable-convert-32-rgb-rot-270 \
	--disable-doc \
	--without-x &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

if [ ! -z "$QI_BOOTMENU_SHARED" ]; then
  install_shared_library evas
  # delete all savers because we don't need them
  rm -rf "$ROOT_DIR/usr/lib/evas/modules/savers"
fi

pkgconfig_fixup_prefix evas
libtool_fixup_libdir evas

cleanup evas
