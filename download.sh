#!/bin/bash

# Download everything we haven't already got a copy of.

source sources/include.sh || exit 1

mkdir -p "$SRCDIR" || dienow

echo "=== Download source code."

# List of fallback mirrors for these files

MIRROR_LIST=

# Note: set SHA1= blank to skip checksum validation.

# A blank SHA1 value means accept anything, and the download script
# prints out the sha1 of such files after downloading it.  So to update to
# a new version of a file, set SHA1= and update the URL, run ./download.sh,
# then cut and paste the sha1 from the output and run it again to confirm.

URL=http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.30.4.tar.bz2 \
SHA1=44504009f86e88da419f593b009475f3255b9e13 \
UNSTABLE=http://kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.31-rc5.tar.bz2 \
download || dienow

URL=http://www.uclibc.org/downloads/uClibc-0.9.30.1.tar.bz2 \
SHA1=4b36fec9a0dacbd6fe0fd2cdb7836aaf8b7f4992 \
UNSTABLE=http://uclibc.org/downloads/uClibc-snapshot.tar.bz2 \
download || dienow

URL=http://www.busybox.net/downloads/busybox-1.14.3.tar.bz2 \
SHA1=0162e2210e7b95396ee35f005929f747ecb9ad8f \
UNSTABLE=http://busybox.net/downloads/busybox-snapshot.tar.bz2 \
download || dienow

URL=http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools-2.0.1.tar.bz2 \
SHA1=d3711794a2161bb88c75b74b5d6b41596e505b25 \
download || dienow

URL=http://www.zlib.net/zlib-1.2.3.tar.bz2 \
SHA1=967e280f284d02284b0cd8872a8e2e04bfdc7283 \
download || dienow

# note there is no backslash at the end because of the symlink hack
URL=http://www.ijg.org/files/jpegsrc.v7.tar.gz 
SHA1=88cced0fc3dbdbc82115e1d08abce4e9d23a4b47 \
download && ln -sf "`echo $URL | sed 's .*/  '`" "$SRCDIR/libjpeg-`echo $URL | sed 's,.*\.\(v.*\),\1,'`"

URL=http://downloads.sourceforge.net/project/libpng/00-libpng-stable/1.2.40/libpng-1.2.40.tar.bz2 \
SHA1=776cf18a799af58303590f6996f6d3aa5a7908ff \
download || dienow

SHA1= SVN_REV=77 \
URL=svn://svn.berlios.de/tslib/trunk/tslib \
download_svn || dienow

URL=http://mirrors.zerg.biz/nongnu/freetype/freetype-2.3.9.tar.bz2 \
SHA1=db08969cb5053879ff9e973fe6dd2c52c7ea2d4e \
download || dienow

SHA1= SVN_REV=42803 \
URL=http://svn.enlightenment.org/svn/e/trunk/eina \
download_svn || dienow

SHA1= SVN_REV=42803 \
URL=http://svn.enlightenment.org/svn/e/trunk/eet \
download_svn || dienow

SHA1= SVN_REV=42803 \
URL=http://svn.enlightenment.org/svn/e/trunk/evas \
download_svn || dienow

SHA1= SVN_REV=42995 \
URL=http://svn.enlightenment.org/svn/e/trunk/ecore \
download_svn || dienow

SHA1= SVN_REV=42803 \
URL=http://svn.enlightenment.org/svn/e/trunk/embryo \
download_svn || dienow

URL=http://www.lua.org/ftp/lua-5.1.4.tar.gz \
SHA1=2b11c8e60306efb7f0734b747588f57995493db7 \
download || dienow

SHA1= SVN_REV=42803 \
URL=http://svn.enlightenment.org/svn/e/trunk/edje \
download_svn || dienow

SHA1= SVN_REV=42803 \
URL=http://svn.enlightenment.org/svn/e/trunk/TMP/st/elementary \
download_svn || dienow

URL=http://matt.ucc.asn.au/dropbear/releases/dropbear-0.52.tar.bz2 \
SHA1=8c1745a9b64ffae79f28e25c6fe9a8b96cac86d8 \
download || dienow

URL=http://www.brain-dump.org/tmp/qi-bootmenu-system/dialog-elementary-v0.tar.bz2 \
SHA1=2661a31ff87b72519fa7f55135a2da45efaf2d40 \
download || dienow

URL=http://users.telenet.be/geertu/Linux/fbdev/fbset-2.1.tar.gz \
SHA1=141c42769818a08f1370a60dc3a809d87530db78 \
download || dienow

URL=http://surfnet.dl.sourceforge.net/project/strace/strace/4.5.18/strace-4.5.18.tar.bz2 \
URL=http://downloads.sourceforge.net/project/strace/strace/4.5.18/strace-4.5.18.tar.bz2 \
SHA1=50081a7201dc240299396f088abe53c07de98e4c \
download || dienow

URL=http://ftp.gnu.org/gnu/gdb/gdb-7.0.tar.bz2 \
SHA1=8aed621b7ddb8c82b6ff213b56c028787db90582 \
download || dienow

echo === Got all source.

cleanup_oldfiles
blank_tempdir "$WORK"

# Set color back to normal.
echo -ne "\e[0m"
