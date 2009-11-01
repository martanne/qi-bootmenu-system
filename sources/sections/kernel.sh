setupfor kernel

[ -z "$MACHINE" ] && MACHINE="GTA02"

VERSION=$(echo $SRCDIR/kernel-* | sed 's .*/  ' | sed -r 's/kernel-(.*)\.tar.*/\1/')
[ -z "$VERSION" ] && VERSION="git"

# kernel load address / entry point
START=30008000

make allnoconfig ARCH="${KARCH}" KCONFIG_ALLCONFIG="$CONFIG_DIR/miniconfig-linux" &&

cp .config "$CONFIG_DIR/config-linux" &&

make -j $CPUS ARCH="$KARCH" CROSS_COMPILE="$CROSS" CONFIG_DEBUG_SECTION_MISMATCH=y $VERBOSITY  && 

${CROSS}objcopy -O binary -R .note -R .comment -S arch/arm/boot/compressed/vmlinux linux.bin &&

mkimage -A arm -O linux -T kernel -C none -a $START -e $START -n "Openmoko $MACHINE Bootmenu" \
	-d linux.bin uImage-$MACHINE.bin &&

make ARCH=$KARCH modules_install CROSS_COMPILE="$CROSS" INSTALL_MOD_PATH="$ROOT_DIR" &&

cp uImage-$MACHINE.bin $TOP 

cleanup kernel
