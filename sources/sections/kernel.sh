setupfor kernel

[ -z "$MACHINE" ] && MACHINE="GTA02"

VERSION=$(echo $SRCDIR/kernel-* | sed 's .*/  ' | sed -r 's/kernel-(.*)\.tar.*/\1/')
[ -z "$VERSION" ] && VERSION="git"

case "$COMPRESSION" in
  none)
    COMPRESSION="Image"
    KERNEL="arch/arm/boot/Image"
    ;;
  *)
    COMPRESSION="zImage"
    KERNEL="arch/arm/boot/zImage"
    ;;
esac

cp "$CONFIG_DIR/miniconfig-linux" config

if [ `grep CONFIG_BLK_DEV_INITRD=y config` ]; then
  echo CONFIG_INITRAMFS_SOURCE=\"$TOP/initramfs-files\" >> config
fi

make allnoconfig ARCH="${KARCH}" KCONFIG_ALLCONFIG="config" || dienow 

cp .config "$CONFIG_DIR/config-linux"

make -j $CPUS ARCH="$KARCH" CROSS_COMPILE="$CROSS" CONFIG_DEBUG_SECTION_MISMATCH=y $VERBOSITY $COMPRESSION || dienow 

if [ `grep CONFIG_MODULES=y .config` ]; then

  make ARCH=$KARCH CROSS_COMPILE="$CROSS" modules || dienow 
  make ARCH=$KARCH INSTALL_MOD_PATH="$ROOT_DIR" modules_install || dienow 

  # remove some broken symlinks from kernel build
  rm -f $ROOT_DIR/lib/modules/*/build
  rm  $ROOT_DIR/lib/modules/*/source
fi

mkimage -A arm -O linux -T kernel -C none -a 0x30008000 -e 0x30008000 -n "Openmoko $MACHINE Bootmenu" \
	-d $KERNEL uImage-$MACHINE.bin || dienow

cp uImage-$MACHINE.bin $TOP 

cleanup kernel
