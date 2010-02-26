setupfor qi-bootmenu 

[ -z "$QI_BOOTMENU_SHARED" ] && TARGET="static"

LDFLAGS="$LDFLAGS -Wl,--gc-section" CFLAGS="$CFLAGS -ffunction-sections -fdata-sections" make $TARGET &&

make PREFIX=/usr DESTDIR="$ROOT_DIR" install

[ $? -ne 0 ] && dienow

cleanup qi-bootmenu
