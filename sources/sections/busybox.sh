# Build and install busybox

setupfor busybox
make allnoconfig KCONFIG_ALLCONFIG="$CONFIG_DIR/miniconfig-busybox" &&
cp .config "$CONFIG_DIR/config-busybox" &&
LDFLAGS="$CROSS_LDFLAGS $LDFLAGS" make -j $CPUS CROSS_COMPILE="$CROSS" $VERBOSITY &&
make busybox.links &&
cp busybox "$ROOT_DIR/usr/bin"

[ $? -ne 0 ] && dienow

for i in $(sed 's@.*/@@' busybox.links)
do
  # Allowed to fail.
  ln -s busybox "$ROOT_DIR/usr/bin/$i" 2>/dev/null
done
cd ..

cleanup busybox
