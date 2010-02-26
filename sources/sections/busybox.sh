setupfor busybox

cp "$CONFIG_DIR/miniconfig-busybox" config 

[ ! -z "$STATIC" ] && echo CONFIG_STATIC=y >> config 

make allnoconfig KCONFIG_ALLCONFIG="config" &&

cp .config "$CONFIG_DIR/config-busybox" &&

LDFLAGS="$LDFLAGS" make -j $CPUS CROSS_COMPILE="$CROSS" CONFIG_PREFIX="$ROOT_DIR" \
	$VERBOSITY install

[ $? -ne 0 ] && dienow

cleanup busybox
