setupfor qi-bootmenu 

echo LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" make &&
LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" make &&

make PREFIX=/usr DESTDIR="$ROOT_DIR" install

[ $? -ne 0 ] && dienow

cleanup qi-bootmenu
