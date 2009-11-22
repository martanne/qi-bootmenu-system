setupfor dialog-elementary 

$CC $CFLAGS `pkg-config --cflags --libs elementary` \
	-lz -ljpeg -lfreetype -lts dialog.c -o dialog || dienow 

cp dialog $STAGING_DIR/usr/bin || dienow
cp dialog $ROOT_DIR/usr/bin || dienow

#$CC $CFLAGS `pkg-config --cflags --libs elementary --static` \
#	-lz -ljpeg -lfreetype -lts -static dialog.c -o dialog-static || dienow 

#cp dialog-static $STAGING_DIR/usr/bin || dienow
#cp dialog-static $ROOT_DIR/usr/bin || dienow 

cleanup dialog-elementary 
