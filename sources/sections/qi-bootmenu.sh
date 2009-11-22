setupfor qi-bootmenu 

LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" make &&

make PREFIX=/usr DESTDIR="$ROOT_DIR" install

[ $? -ne 0 ] && dienow

cleanup qi-bootmenu
