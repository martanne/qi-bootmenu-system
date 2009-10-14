# Lots of reusable functions.  This file is sourced, not run.

function blank_tempdir()
{
  # sanity test: never rm -rf something we don't own.
  [ -z "$1" ] && dienow
  touch -c "$1" || dienow

  # Delete old directory, create new one.
  rm -rf "$1"
  mkdir -p "$1" || dienow
}

# Figure out if we're using the stable or unstable versions of a package.

function unstable()
{
  [ ! -z "$(echo ,"$USE_UNSTABLE", | grep ,"$1",)" ]
}

# Strip the version number off a tarball

function cleanup()
{

  [ $? -ne 0 ] && dienow

  if [ ! -z "$NO_CLEANUP" ]
  then
    echo "skip cleanup $@"
    return
  fi

  for i in "$@"
  do
    unstable "$i" && i="$PACKAGE"
    echo "cleanup $i"
    rm -rf "$i" || dienow
 done
}

# Give filename.tar.ext minus the version number.

function noversion()
{
  echo "$1" | sed -e 's/-*\(\([0-9\.]\)*\([_-]rc\)*\(-pre\)*\([0-9][a-zA-Z]\)*\)*\(\.tar\..z2*\)$/'"$2"'\6/'
}

# Given a filename.tar.ext, return the versino number.

function getversion()
{
  echo "$1" | sed -e 's/.*-\(\([0-9\.]\)*\([_-]rc\)*\(-pre\)*\([0-9][a-zA-Z]\)*\)*\(\.tar\..z2*\)$/'"$2"'\1/'
}

# Give package name, minus file's version number and archive extension.

function basename()
{
  noversion $1 | sed 's/\.tar\..z2*$//'
}

# output the sha1sum of a file
function sha1file()
{
  sha1sum "$@" | awk '{print $1}'
}

# Extract tarball named in $1 and apply all relevant patches into
# "$BUILD/sources/$1".  Record sha1sum of tarball and patch files in
# sha1-for-source.txt.  Re-extract if tarball or patches change.

function extract()
{
  FILENAME="$1"
  SRCTREE="${BUILD}/sources"
  SHA1FILE="$(echo "${SRCTREE}/${PACKAGE}/sha1-for-source.txt")"

  # Sanity check: don't ever "rm -rf /".  Just don't.

  if [ -z "$PACKAGE" ] || [ -z "$SRCTREE" ]
  then
    dienow
  fi

  # If the source tarball doesn't exist, but the extracted directory is there,
  # assume everything's ok.

  [ ! -e "$FILENAME" ] && [ -e "$SHA1FILE" ] && return 0

  SHA1TAR="$(sha1file "${SRCDIR}/${FILENAME}")"

  # If it's already extracted and up to date (including patches), do nothing.
  SHALIST=$(cat "$SHA1FILE" 2> /dev/null)
  if [ ! -z "$SHALIST" ]
  then
    for i in "$SHA1TAR" $(sha1file "${SOURCES}/patches/${PACKAGE}"-* 2>/dev/null)
    do
      # Is this sha1 in the file?
      if [ -z "$(echo "$SHALIST" | sed -n "s/$i/$i/p" )" ]
      then
        SHALIST=missing
        break
      fi
      # Remove it
      SHALIST="$(echo "$SHALIST" | sed "s/$i//" )"
    done
    # If we matched all the sha1sums, nothing more to do.
    [ -z "$SHALIST" ] && return 0
  fi

  echo -n "Extracting '${PACKAGE}'"
  # Delete the old tree (if any).  Create new empty working directories.
  rm -rf "${BUILD}/temp" "${SRCTREE}/${PACKAGE}" 2>/dev/null
  mkdir -p "${BUILD}"/{temp,sources} || dienow

  # Is it a bzip2 or gzip tarball?
  DECOMPRESS=""
  [ "$FILENAME" != "${FILENAME/%\.tar\.bz2/}" ] && DECOMPRESS="j"
  [ "$FILENAME" != "${FILENAME/%\.tar\.gz/}" ] && DECOMPRESS="z"

  cd "${WORK}" &&
  { tar -xv${DECOMPRESS} -f "${SRCDIR}/${FILENAME}" -C "${BUILD}/temp" || dienow
  } | dotprogress

  mv "${BUILD}/temp/"* "${SRCTREE}/${PACKAGE}" &&
  rmdir "${BUILD}/temp" &&
  echo "$SHA1TAR" > "$SHA1FILE"

  [ $? -ne 0 ] && dienow

  # Apply any patches to this package

  ls "${SOURCES}/patches/${PACKAGE}"-* 2> /dev/null | sort | while read i
  do
    if [ -f "$i" ]
    then
      echo "Applying $i"
      (cd "${SRCTREE}/${PACKAGE}" && patch -p1 -i "$i") || dienow
      sha1file "$i" >> "$SHA1FILE"
    fi
  done
}

function try_checksum()
{
  SUM="$(sha1file "$SRCDIR/$FILENAME" 2>/dev/null)"
  if [ x"$SUM" == x"$SHA1" ] || [ -z "$SHA1" ] && [ -f "$SRCDIR/$FILENAME" ]
  then
    if [ -z "$SHA1" ]
    then
      echo "No SHA1 for $FILENAME ($SUM)"
    else
      echo "Confirmed $FILENAME"
    fi

    # Preemptively extract source packages?

    [ -z "$EXTRACT_ALL" ] && return 0
    EXTRACT_ONLY=1 setupfor "$(basename "$FILENAME")"
    return $?
  fi

  return 1
}


function try_download()
{
  # Return success if we have a valid copy of the file

  try_checksum && return 0

  # If there's a corrupted file, delete it.  In theory it would be nice
  # to resume downloads, but wget creates "*.1" files instead.

  rm "$SRCDIR/$FILENAME" 2> /dev/null

  # If we have another source, try to download file.

  if [ -n "$1" ]
  then
    wget -t 2 -T 20 -O "$SRCDIR/$FILENAME" "$1" ||
      (rm "$SRCDIR/$FILENAME"; return 2)
    touch -c "$SRCDIR/$FILENAME"
  fi

  try_checksum
}

# Confirm a file matches sha1sum, else try to download it from mirror list.

function download()
{
  FILENAME=`echo "$URL" | sed 's .*/  '`
  [ -z "$RENAME" ] || FILENAME="$(echo "$FILENAME" | sed -r "$RENAME")"
  ALTFILENAME=alt-"$(noversion "$FILENAME" -0)"

  echo -ne "checking $FILENAME\r"

  # Update timestamps on both stable and unstable tarballs (if any)
  # so cleanup_oldfiles doesn't delete them
  touch -c "$SRCDIR"/{"$FILENAME","$ALTFILENAME"} 2>/dev/null

  # Is the unstable version selected?
  if unstable "$(basename "$FILENAME")"
  then
    # Download new one as alt-packagename.tar.ext
    FILENAME="$ALTFILENAME" SHA1= try_download "$UNSTABLE" ||
      ([ ! -z "$PREFERRED_MIRROR" ] && SHA1= FILENAME="$ALTFILENAME" try_download "$PREFERRED_MIRROR/$ALTFILENAME")
    return $?
  fi

  # If environment variable specifies a preferred mirror, try that first.

  if [ ! -z "$PREFERRED_MIRROR" ]
  then
    try_download "$PREFERRED_MIRROR/$FILENAME" && return 0
  fi

  # Try standard locations
  # Note: the URLs in mirror list cannot contain whitespace.

  try_download "$URL" && return 0
  for i in $MIRROR_LIST
  do
    try_download "$i/$FILENAME" && return 0
  done

  # Return failure.

  echo "Could not download $FILENAME"
  echo -en "\e[0m"
  return 1
}

# Clean obsolete files out of the source directory

START_TIME=`date +%s`

function cleanup_oldfiles()
{
  for i in "${SRCDIR}"/*
  do
    if [ -f "$i" ] && [ "$(date +%s -r "$i")" -lt "${START_TIME}" ]
    then
      echo Removing old file "$i"
      rm -rf "$i"
    fi
  done
}

# An exit function that works properly even from a subshell.

function actually_dienow()
{
  echo -e "\n\e[31mExiting due to errors ($PACKAGE)\e[0m"
  exit 1
}

trap actually_dienow SIGUSR1
TOPSHELL=$$

function dienow()
{
  kill -USR1 $TOPSHELL
  exit 1
}

# Turn a bunch of output lines into a much quieter series of periods.

function dotprogress()
{
  x=0
  while read i
  do
    x=$[$x + 1]
    if [[ "$x" -eq 25 ]]
    then
      x=0
      echo -n .
    fi
  done
  echo
}

# Extract package $1, use out-of-tree build directory $2 (or $1 if no $2)
# Use link directory $3 (or $1 if no $3)

function setupfor()
{
  export WRAPPY_LOGPATH="$WRAPPY_LOGDIR/cmdlines.${STAGE_NAME}.setupfor"

  # Figure out whether we're using an unstable package.

  PACKAGE="$1"
  unstable "$PACKAGE" && PACKAGE=alt-"$PACKAGE"

  # Make sure the source is already extracted and up-to-date.
  cd "${SRCDIR}" &&
  extract "${PACKAGE}-"*.tar* || exit 1

  # If all we want to do is extract source, bail out now.
  [ ! -z "$EXTRACT_ONLY" ] && return 0

  # Set CURSRC
  CURSRC="$PACKAGE"
  if [ ! -z "$3" ]
  then
    CURSRC="$3"
    unstable "$CURSRC" && CURSRC=alt-"$CURSRC"
  fi
  export CURSRC="${WORK}/${CURSRC}"

  [ -z "$SNAPSHOT_SYMLINK" ] && LINKTYPE="l" || LINKTYPE="s"

  # Announce package, with easy-to-grep-for "===" marker.

  echo "=== Building $PACKAGE ($ARCH_NAME $STAGE_NAME)"
  echo "Snapshot '$PACKAGE'..."
  cd "${WORK}" || dienow
  if [ $# -lt 3 ]
  then
    rm -rf "${CURSRC}" || dienow
  fi
  mkdir -p "${CURSRC}" &&
  cp -${LINKTYPE}fR "${SRCTREE}/$PACKAGE/"* "${CURSRC}"

  [ $? -ne 0 ] && dienow

  # Do we have a separate working directory?

  if [ -z "$2" ]
  then
    cd "$PACKAGE"* || dienow
  else
    mkdir -p "$2" && cd "$2" || dienow
  fi
  export WRAPPY_LOGPATH="$WRAPPY_LOGDIR/cmdlines.${STAGE_NAME}.$1"

  # Change window title bar to package now
  [ -z "$NO_TITLE_BAR" ] &&
    echo -en "\033]2;$ARCH_NAME $STAGE_NAME $PACKAGE\007"
}

# Figure out what version of a package we last built

function get_download_version()
{
  getversion $(sed -n 's@URL=.*/\(.[^ ]*\).*@\1@p' "$TOP/download.sh" | grep ${1}-)
}

# Filter out unnecessary noise

maybe_quiet()
{
  [ -z "$QUIET" ] && cat || grep "^==="
}

# Run a command either in foreground or background, depending on $FORK

maybe_fork()
{
  if [ -z "$FORK" ]
  then
    eval "$*"
  else
    eval "$*" &
  fi
}

# Kill a process and all its decendants

function killtree()
{
  local KIDS=""

  while [ $# -ne 0 ]
  do
    KIDS="$KIDS $(pgrep -P$1)"
    shift
  done

  KIDS="$(echo -n $KIDS)"
  if [ ! -z "$KIDS" ]
  then
    # Depth first kill avoids reparent_to_init hiding stuff.
    killtree $KIDS
    kill $KIDS 2>/dev/null
  fi
}
