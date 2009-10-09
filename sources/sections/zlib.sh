setupfor zlib

# building static lib
./configure --prefix=/usr && 
make &&
make prefix="$STAGING_DIR/usr" install || dienow

# building shared lib
./configure --prefix=/usr \
--shared &&
make &&
make prefix="$STAGING_DIR/usr" install || dienow

cp -P $STAGING_DIR/usr/lib/libz.so* $ROOT_DIR/usr/lib || dienow

cleanup zlib
