setupfor freetype

cp "$CONFIG_DIR/freetype-modules.cfg" modules.cfg

for c in \
	FT_CONFIG_OPTION_USE_LZW \
	FT_CONFIG_OPTION_USE_ZLIB \
	FT_CONFIG_OPTION_POSTSCRIPT_NAMES \
	FT_CONFIG_OPTION_ADOBE_GLYPH_LIST \
	FT_CONFIG_OPTION_MAC_FONTS \
	TT_CONFIG_OPTION_GX_VAR_SUPPORT \
	TT_CONFIG_OPTION_BDF \
	TT_CONFIG_OPTION_SFNT_NAMES \
	AF_CONFIG_OPTION_CJK \
	AF_CONFIG_OPTION_INDIC \
	FT_CONFIG_OPTION_OLD_INTERNALS  
do
	sed -i 's,^#define '$c',/* & */,g' include/freetype/config/ftoption.h
done

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure $CROSS_CONFIGURE_FLAGS --prefix=/usr &&
make &&
make DESTDIR="$STAGING_DIR" install || dienow

if [ ! -z "$QI_BOOTMENU_SHARED" ]; then
  cp -P $STAGING_DIR/usr/lib/libfreetype.so* $ROOT_DIR/usr/lib || dienow
fi

pkgconfig_fixup_prefix freetype 
libtool_fixup_libdir freetype

cleanup freetype
