setupfor busybox

make allnoconfig KCONFIG_ALLCONFIG="$CONFIG_DIR/miniconfig-busybox" &&

cp .config "$CONFIG_DIR/config-busybox" &&

LDFLAGS="$CROSS_LDFLAGS $LDFLAGS" make -j $CPUS CROSS_COMPILE="$CROSS" CONFIG_PREFIX="$ROOT_DIR" \
	$VERBOSITY install

[ $? -ne 0 ] && dienow

cleanup busybox
