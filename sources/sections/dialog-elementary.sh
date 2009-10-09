setupfor dialog-elementary 

$CC `pkg-config --cflags --libs elementary` -lz -ljpeg -lfreetype -lts \
	dialog.c -o dialog || dienow 

cp dialog $ROOT_DIR/usr/bin || dienow 

cleanup dialog-elementary 
