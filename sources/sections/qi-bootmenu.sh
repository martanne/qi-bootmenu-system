setupfor qi-bootmenu 

LDFLAGS="$CROSS_LDFLAGS $LDFLAGS" CFLAGS="$CROSS_CFLAGS $CFLAGS" make &&

make PREFIX=/usr DESTDIR="$ROOT_DIR" install

[ $? -ne 0 ] && dienow

cleanup qi-bootmenu
