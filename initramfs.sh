#!/bin/bash

source sources/include.sh || exit 1

cd $TOP || dienow

# copy root overlay

tar -C "$ROOT_OVERLAY" -cf - . | tar -C "$ROOT_DIR" -xf -

if [ -z "$NO_STRIP" ]; then
	# strip all binaries
	${STRIP} "$ROOT_DIR"/usr/{bin/*,sbin/*} 2> /dev/null
	find "$ROOT_DIR/usr/lib" -name '*.so' | xargs ${STRIP} --strip-unneeded 2>/dev/null

	# remove libthread_db which is used for cross debuging with gdb
	rm "$ROOT_DIR/lib/libthread_db*"
fi

# generate file with the contents of the initramfs it's later used
# by the kernel build system to create a gziped cpio archive which
# is then embedded into the kernel binary.

$SCRIPTS/gen_initramfs_list.sh -u squash -g squash $ROOT_DIR > \
	initramfs-files

# Add some more device nodes 

echo "nod /dev/tty 644 0 0 c 5 0" >> initramfs-files
echo "nod /dev/tty0 644 0 0 c 4 0" >> initramfs-files
echo "nod /dev/tty1 644 0 0 c 4 1" >> initramfs-files
echo "nod /dev/tty2 644 0 0 c 4 2" >> initramfs-files
echo "nod /dev/ttyGS0 644 0 0 c 253 0" >> initramfs-files
echo "nod /dev/ttySAC2 644 0 0 c 204 66" >> initramfs-files
echo "nod /dev/console 622 0 0 c 5 1" >> initramfs-files
echo "nod /dev/null 622 0 0 c 1 3" >> initramfs-files
echo "nod /dev/fb0 644 0 0 c 29 0" >> initramfs-files

echo "Specify initramfs-files during kernel compilation as CONFIG_INITRAMFS_SOURCE"
echo "or run ./package.sh to create rootfs.tar.gz tarball for a chroot environment." 
