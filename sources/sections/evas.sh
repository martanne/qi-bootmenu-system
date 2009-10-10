setupfor evas

[ ! -e ./configure ] && NOCONFIGURE=y ./autogen.sh

# depends on freetype
#
# we build with libjpeg because it's already there as dependency of eet
#
# evas doesn't seem to like certain compiler flags. For example it segfaults
# in evas_object_color_set when compiled with:
#
#   -Os -pipe -march=armv4t -mtune=arm9tdmi
#
# we therefore ignore the global $CFLAGS and just use $CFLAGS_HEADERS here. 

LDFLAGS="$CROSS_LDFLAGS $LDFLAGS" CFLAGS="$CFLAGS_HEADERS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr \
	--enable-fb \
	--disable-directfb \
	--disable-sdl \
	--enable-buffer	\
	--disable-evas-cserve \
	--disable-software-ddraw \
	--disable-software-qtopia \
	--disable-software-xlib	\
	--disable-software-16-x11 \
	--disable-software-xcb \
	--disable-gl-x11 \
	--disable-xrender-x11 \
	--disable-xrender-xcb \
	--disable-glitz-x11 \
	--enable-image-loader-eet \
	--disable-image-loader-edb \
	--disable-image-loader-gif \
	--disable-image-loader-png \
	--disable-image-loader-pmaps \
	--enable-image-loader-jpeg \
	--disable-image-loader-tiff \
	--disable-image-loader-xpm \
	--disable-image-loader-svg \
	--enable-cpu-c \
	--disable-evas-magic-debug \
	--disable-fontconfig \
	--enable-font-loader-eet \
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

install_shared_library evas
# delete all savers because we don't need them
rm -rf "$ROOT_DIR/usr/lib/evas/modules/savers"

pkgconfig_fixup_prefix evas
libtool_fixup_libdir evas

cleanup evas
