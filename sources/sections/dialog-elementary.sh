setupfor dialog-elementary 

$CC $CFLAGS $CROSS_CFLAGS `pkg-config --cflags --libs elementary` \
	-lz -ljpeg -lfreetype -lts dialog.c -o dialog || dienow 

#$CC $CFLAGS $CROSS_CFLAGS `pkg-config --cflags --libs elementary --static` \
#	-lz -ljpeg -lfreetype -lts -static dialog.c -o dialog-static || dienow 

cp dialog $ROOT_DIR/usr/bin || dienow 
#cp dialog-static $ROOT_DIR/usr/bin || dienow 

cleanup dialog-elementary 
