# Build and install uClibc.

setupfor uClibc
make CROSS="$CROSS" KCONFIG_ALLCONFIG="$SOURCES/miniconfig-uClibc" allnoconfig &&
cp .config "$SOURCES/config-uClibc" || dienow

UCLIBC_MAKE_FLAGS="CROSS=$CROSS KERNEL_HEADERS=$STAGING_DIR/usr/include \
	RUNTIME_PREFIX=/ UCLIBC_LDSO_NAME=ld-uClibc $VERBOSITY"

# prepare the headers files this is a pre requirement for locale generation

make $UCLIBC_MAKE_FLAGS PREFIX="$STAGING_DIR/usr" DEVEL_PREFIX="/" headers
make $UCLIBC_MAKE_FLAGS PREFIX="$STAGING_DIR/usr" DEVEL_PREFIX="/" include/bits/sysnum.h 

# configure/generate just the minimal needed locales
# UCLIBC_BUILD_MINIMAL_LOCALE doesn't seem to be present
# in the Kconfig files but it is nevertheless used in the
# Makefile

cd extra/locale
make clean
make $UCLIBC_MAKE_FLAGS PREFIX="$STAGING_DIR/usr" UCLIBC_BUILD_MINIMAL_LOCALE=y DEVEL_PREFIX="/"
cd - >/dev/null

# build and install into $STAGING_DIR

make $UCLIBC_MAKE_FLAGS PREFIX="$STAGING_DIR/usr" DEVEL_PREFIX="/" -j $CPUS install
make $UCLIBC_MAKE_FLAGS PREFIX="$STAGING_DIR/usr" DEVEL_PREFIX="/" -j $CPUS install_utils

# install into $ROOT_DIR 

make $UCLIBC_MAKE_FLAGS PREFIX="$ROOT_DIR" install_runtime

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
