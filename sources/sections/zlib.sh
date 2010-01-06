setupfor zlib

# building static lib
./configure --prefix=/usr && 
make &&
make prefix="$STAGING_DIR/usr" install || dienow

# building shared lib
LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" ./configure --prefix=/usr --shared &&
make prefix="$STAGING_DIR/usr" install || dienow

if [ -z "$STATIC" ]; then
  cp -P $STAGING_DIR/usr/lib/libz.so* $ROOT_DIR/usr/lib || dienow
fi

cleanup zlib
