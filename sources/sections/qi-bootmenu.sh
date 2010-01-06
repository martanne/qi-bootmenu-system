setupfor qi-bootmenu 

[ ! -z "$STATIC" ] && TARGET="static"

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" make $TARGET &&

make PREFIX=/usr DESTDIR="$ROOT_DIR" install

[ $? -ne 0 ] && dienow

cleanup qi-bootmenu
