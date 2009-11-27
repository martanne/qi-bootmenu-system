#!/bin/bash

source sources/include.sh || exit 1

cd $TOP || dienow

# copy root overlay

tar -C "$ROOT_OVERLAY" -cf - . | tar -C "$ROOT_DIR" -xf -

if [ -z "$NO_STRIP" ]; then
	# strip all binaries
	${STRIP} "$ROOT_DIR"/usr/{bin/*,sbin/*} 2> /dev/null
	find "$ROOT_DIR/usr/lib" -name '*.so' | xargs ${STRIP} --strip-unneeded 2>/dev/null
	[ -e "$ROOT_DIR/lib/modules" ] &&  find "$ROOT_DIR/lib/modules" -name '*.ko' | xargs ${STRIP}

	# remove libthread_db which is used for cross debuging with gdb
	rm -f "$ROOT_DIR"/lib/libthread_db*
fi

# generate file with the contents of the initramfs it's later used
# by the kernel build system to create a gziped cpio archive which
# is then embedded into the kernel binary.

$SCRIPTS/gen_initramfs_list.sh -u squash -g squash $ROOT_DIR > \
	initramfs-files

echo "Now run './build.sh kernel' which will build a kernel with initramfs-files as"
echo "CONFIG_INITRAMFS_SOURCE or run ./package.sh to create a rootfs.tar.gz tarball"
echo "that you can extract on a SD card."
