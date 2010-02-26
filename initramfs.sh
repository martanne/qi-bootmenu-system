#!/bin/bash

source sources/include.sh || exit 1

cd $TOP || dienow

# copy root overlay

tar -C "$ROOT_OVERLAY" -cf - . | tar -C "$ROOT_DIR" -xf -

libs=""

# remove all shared libraries which aren't needed

if [ -z "$NO_STRIP" ]; then

# get library dependencies of binaries

for f in `find $ROOT_DIR/usr/bin $ROOT_DIR/usr/sbin -type f -perm +0111`; do
	if [ ! -z "`file $f | grep ELF | grep executable`" ]; then
		for l in `${CROSS}objdump -p $f | awk '/NEEDED/ { print $2 }'`; do
			libs="$libs $l"
		done
	fi
done

# get dependencies of the dependencies (should use recursion) 

for l in `find $ROOT_DIR/usr/lib -type f -perm +0111`; do
	soname="`${CROSS}objdump -p $l | awk '/SONAME/ { print $2 }'`"
	if [[ ! -z $soname && ! -z "`echo $libs | grep $soname`" ]]; then
		needed="`${CROSS}objdump -p $l | awk '/NEEDED/ { print $2 }'`"
		libs="$libs $needed"
	fi
done

# remove unused sub directories which contain plugin/modules

for l in `find $ROOT_DIR/usr/lib -mindepth 1 -maxdepth 1 -type d -perm +0111`; do
	if [ ! -z "`echo $libs | grep $l`" ]; then
		echo deleteing $l
		rm -rf "$l"
	else
		# modules required so get all dependencies
		for m in `find $l -type f -perm +0111`; do
			for ml in `${CROSS}objdump -p $m | awk '/NEEDED/ { print $2 }'`; do
				libs="$libs $ml"
			done
		done
	fi
done

# delete all libraries which aren't referenced by others

for l in `find $ROOT_DIR/usr/lib -maxdepth 1 ! -type d -perm +0111`; do
	if [ ! -e "$l" ]; then # remove broken symlinks
		rm -f "$l"
	else
		soname="`${CROSS}objdump -p $l | awk '/SONAME/ { print $2 }' 2> /dev/null`"
		if [[ ! -z $soname && -z "`echo $libs | grep $soname`" ]]; then
			rm "$l"
		fi
	fi
done

# strip binaries and libraries

${STRIP} -s -R .note -R .comment "$ROOT_DIR"/usr/{bin/*,sbin/*} 2> /dev/null
find "$ROOT_DIR/usr/lib" -name '*.so' | xargs ${STRIP} --strip-unneeded 2>/dev/null
[ -e "$ROOT_DIR/lib/modules" ] &&  find "$ROOT_DIR/lib/modules" -name '*.ko' | xargs ${STRIP}

# remove libthread_db which is used for cross debuging with gdb
rm -f "$ROOT_DIR"/lib/libthread_db*

fi # $NO_STRIP

# generate file with the contents of the initramfs it's later used
# by the kernel build system to create a gziped cpio archive which
# is then embedded into the kernel binary.

$SCRIPTS/gen_initramfs_list.sh -u squash -g squash $ROOT_DIR > \
	initramfs-files

echo "Now run './build.sh kernel' which will build a kernel with initramfs-files as"
echo "CONFIG_INITRAMFS_SOURCE or run ./package.sh to create a rootfs.tar.gz tarball"
echo "that you can extract on a SD card."
