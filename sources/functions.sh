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

# Try to download a given revision from a svn repository 

function download_svn()
{

  # In a first step get a tarball filename for the requested revison

  [ -z "$SVN_REV" ] && SVN_REV="HEAD"

  PACKAGE=`echo "$URL" | sed 's .*/  '`
  DIRNAME=$PACKAGE-r$SVN_REV
  FILENAME=$PACKAGE-r$SVN_REV.tar.bz2
  
  # Update timestamp so cleanup_oldfiles doesn't delete it 
  touch -c "$SRCDIR/$FILENAME" 2>/dev/null

  # Return success if we have a valid copy of the file
  try_checksum && return 0

  echo Checking out $PACKAGE revision $SVN_REV from svn repository
  # Checkout files from source repository if no revison was
  # requested find out which revison current HEAD is and
  # package everything into a tarball.
  svn co --non-interactive -r$SVN_REV "$URL" "$SRCDIR/$PACKAGE" | dotprogress || return 1
 
  if [ "x$SVN_REV" = "xHEAD" ]; then
    cd "$SRCDIR/$PACKAGE" && 
    DIRNAME="$PACKAGE-r$(svn info | grep Revision: | sed 's/Revision: //')" && 
    cd - 1> /dev/null
  fi

  mv "$SRCDIR/$PACKAGE" "$SRCDIR/$DIRNAME" &&
  find "$SRCDIR/$DIRNAME" -name .svn | xargs rm -rf &&
  tar -C "$SRCDIR" -cjf "$SRCDIR/$DIRNAME.tar.bz2" "$DIRNAME" &&
  rm -rf "$SRCDIR/$DIRNAME" && return 0 

  return 1
}

# Note that this sources the file, rather than calling it as a separate
# process.  That way it can set environment variables if it wants to.

function build_package()
{
  [ ! -f "$SOURCES"/sections/"$1".sh ] && echo "Unknown package: $1" && exit 1
  . "$SOURCES"/sections/"$1".sh
}
