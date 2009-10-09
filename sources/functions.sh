# Lots of reusable functions.  This file is sourced, not run.

# libraries are configured with --prefix=/usr to run on
# the final system but they are then installed with
# make DESTDIR="..." install or similar to temporary 
# staging directory where other libs can be cross compiled
# against them.
#
# This doesn't work because libtool will hardwire paths
# to /usr/lib in it's *.la files and this leds the cross
# compiler to link against libraries from the host system
# which of course doesn't work.
#
# We therefore prefix every path in the *.la files with our
# temporary staging dir.
#
# This was mostly taken from OpenWRT's autotools.mk 

function libtool_fixup_libdir() {
  cd "$STAGING_DIR/usr/lib"
  find . -name $1\*.la -o -name lib$1\*.la -o -path ./$1/\*.la | xargs \
    sed -i "s,\(^libdir='\| \|-L\|^dependency_libs='\)/usr/lib,\1$STAGING_DIR/usr/lib,g"
  cd - > /dev/null
}

# In theory this should be controllable with the $PKG_CONFIG_SYSROOT_DIR
# environment variable but this feature was introduced in pkg-config 0.23
# and Debian unstable still ships with 0.22 so we hardwire the paths.

function pkgconfig_fixup_prefix() {
  find "$STAGING_DIR/usr/lib/pkgconfig" -name $1\*.pc | xargs \
    sed -i "s,^prefix=.*$,prefix=$STAGING_DIR/usr,g"
}

function install_shared_library() {
  cp -P $STAGING_DIR/usr/lib/lib$1*.so* $ROOT_DIR/usr/lib || dienow
  if [ -d "$STAGING_DIR/usr/lib/$1" ]
  then
    cd $STAGING_DIR/usr/lib
    find $1 -name '*.so' | xargs tar -cf - | tar -xf - -C $ROOT_DIR/usr/lib
    cd - > /dev/null
  fi
}

function create_rootfs_tarball()
{
  echo -n creating rootfs.tar.gz
  { tar -C "$ROOT_DIR" -czvf rootfs.tar.gz . || dienow
  } | dotprogress
}
