setupfor kernel

# Install Linux kernel headers (for use by uClibc).
make headers_install -j "$CPUS" ARCH="${KARCH}" INSTALL_HDR_PATH="$STAGING_DIR/usr" &&

# This makes some very old package builds happy.
ln -s ../sys/user.h "$STAGING_DIR/usr/include/asm/page.h" &&

cleanup kernel
