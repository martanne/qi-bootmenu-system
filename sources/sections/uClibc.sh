# Build and install uClibc.

setupfor uClibc

# We need to unset the environment variable for ccwrap from include.sh
# because there is no libc to link against we are building it here.
# The reason why it is set in include.sh is that it works for manual
# package builds ala ./build.sh qi-bootmenu 

OLD_CCWRAP_TOPDIR=$CCWRAP_TOPDIR
unset CCWRAP_TOPDIR

make CROSS="$CROSS" KCONFIG_ALLCONFIG="$CONFIG_DIR/miniconfig-uClibc" allnoconfig &&
cp .config "$CONFIG_DIR/config-uClibc" || dienow

UCLIBC_MAKE_FLAGS="CROSS=$CROSS KERNEL_HEADERS=$STAGING_DIR/usr/include \
	RUNTIME_PREFIX=/ UCLIBC_LDSO_NAME=ld-uClibc $VERBOSITY"

# build and install into $STAGING_DIR

make $UCLIBC_MAKE_FLAGS PREFIX="$STAGING_DIR/usr" DEVEL_PREFIX="/" -j $CPUS install &&
make $UCLIBC_MAKE_FLAGS PREFIX="$STAGING_DIR/usr" DEVEL_PREFIX="/" -j $CPUS install_utils

[ $? -ne 0 ] && dienow

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

# copy compiler related include files and into $STAGING_DIR
# so that the compiler wrapper (ccwrap) will find it were it
# expects them.

cp -r "$(dirname $(which $CC))/../cc" "$STAGING_DIR/usr" || dienow

# tell the compiler wrapper to link all further packages 
# against the newly built libc 

export CCWRAP_TOPDIR=$OLD_CCWRAP_TOPDIR

cleanup uClibc
