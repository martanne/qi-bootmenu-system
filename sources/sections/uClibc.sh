# Build and install uClibc.

setupfor uClibc
make CROSS="$CROSS" KCONFIG_ALLCONFIG="$SOURCES/miniconfig-uClibc" allnoconfig &&
cp .config "$SOURCES/config-uClibc" || dienow

# Alas, if we feed install and install_utils to make at the same time with
# -j > 1, it dies.  Not SMP safe.
for i in install install_utils
do
  make CROSS="$CROSS" KERNEL_HEADERS="$STAGING_DIR/usr/include" \
       PREFIX="$STAGING_DIR/usr" $VERBOSITY \
       RUNTIME_PREFIX="/" DEVEL_PREFIX="/" \
       UCLIBC_LDSO_NAME=ld-uClibc -j $CPUS $i || dienow
done

make CROSS="$CROSS" KERNEL_HEADERS="$STAGING_DIR/usr/include" \
     PREFIX="$ROOT_DIR" RUNTIME_PREFIX="/" \
     UCLIBC_LDSO_NAME=ld-uClibc V=1 install_runtime

#cd ..

[ -e "$STAGING_DIR/usr/lib/libc.so" ] && cp "$STAGING_DIR/usr/lib/libc.so" \
	"$ROOT_DIR/lib/libc.so" 

# remove some hardwired paths from libc.so linker script
# which point to / because of RUNTIME_PREFIX which would 
# try to leak in bits from the host system. Maybe we should
# install uClibc twice with different RUNTIME_PREFIX one
# for the STAGING_DIR and one for the rootfs /.

[ -e "$STAGING_DIR/usr/lib/libc.so" ] && \
	sed -i 's,/lib/,,g' "$STAGING_DIR/usr/lib/libc.so" 
 
# delete the headers, static libs and example source code.

#rm -rf "$ROOT_DIR/usr/include" &&
#rm -rf "$ROOT_DIR"/usr/lib/*.a &&
#rm -rf "$ROOT_DIR/usr/src" || dienow

cleanup uClibc
