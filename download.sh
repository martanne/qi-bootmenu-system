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

URL='http://git.openmoko.org/?p=kernel.git;a=snapshot;h=a03f58c61cb66164aa40cbf7bf3ff5f24a6f658b;sf=tgz' \
SHA1= \
RENAME="s/.*h=(.*);.*/kernel-\1.tar.gz/" \
download || dienow

URL=http://www.uclibc.org/downloads/uClibc-0.9.30.1.tar.bz2 \
SHA1=4b36fec9a0dacbd6fe0fd2cdb7836aaf8b7f4992 \
download || dienow

URL=http://www.busybox.net/downloads/busybox-1.15.2.tar.bz2 \
SHA1=2f396a4cb35db438a9b4af43df6224f343b8a7ae \
download || dienow

URL='http://git.kernel.org/?p=linux/kernel/git/horms/kexec-tools.git;a=snapshot;h=d61381a70a57a01b87afee90c976675f047d447d;sf=tgz' \
SHA1= \
RENAME="s/.*h=(.*);.*/kexec-tools-\1.tar.gz/" \
download || dienow

URL=http://www.zlib.net/zlib-1.2.3.tar.bz2 \
SHA1=967e280f284d02284b0cd8872a8e2e04bfdc7283 \
download || dienow

URL=http://www.ijg.org/files/jpegsrc.v7.tar.gz \
SHA1=88cced0fc3dbdbc82115e1d08abce4e9d23a4b47 \
RENAME="s/jpegsrc\.(.*)/libjpeg-\1/" \
download || dienow

URL=http://downloads.sourceforge.net/project/libpng/00-libpng-stable/1.2.40/libpng-1.2.40.tar.bz2 \
SHA1=776cf18a799af58303590f6996f6d3aa5a7908ff \
download || dienow

SHA1= SVN_REV=77 \
URL=svn://svn.berlios.de/tslib/trunk/tslib \
download_svn || dienow

URL=http://mirrors.zerg.biz/nongnu/freetype/freetype-2.3.9.tar.bz2 \
SHA1=db08969cb5053879ff9e973fe6dd2c52c7ea2d4e \
download || dienow

URL=http://download.enlightenment.org/snapshots/2009-12-02/eina-0.9.9.063.tar.bz2 \
SHA1= \
download || dienow

URL=http://download.enlightenment.org/releases/eet-1.2.3.tar.bz2 \
SHA1= \
download || dienow

URL=http://download.enlightenment.org/snapshots/2009-12-02/evas-0.9.9.063.tar.bz2 \
SHA1= \
download || dienow

URL=http://download.enlightenment.org/snapshots/2009-12-02/ecore-0.9.9.063.tar.bz2 \
SHA1= \
download || dienow

URL=http://download.enlightenment.org/snapshots/2009-12-02/embryo-0.9.9.063.tar.bz2 \
SHA1= \
download || dienow

URL=http://www.lua.org/ftp/lua-5.1.4.tar.gz \
SHA1=2b11c8e60306efb7f0734b747588f57995493db7 \
download || dienow

URL=http://download.enlightenment.org/snapshots/2009-12-02/edje-0.9.93.063.tar.bz2 \
SHA1= \
download || dienow

URL=http://download.enlightenment.org/snapshots/2009-12-02/elementary-0.6.0.063.tar.bz2 \
SHA1= \
download || dienow

URL=http://matt.ucc.asn.au/dropbear/releases/dropbear-0.52.tar.bz2 \
SHA1=8c1745a9b64ffae79f28e25c6fe9a8b96cac86d8 \
download || dienow

URL=http://downloads.sourceforge.net/project/strace/strace/4.5.18/strace-4.5.18.tar.bz2 \
SHA1=50081a7201dc240299396f088abe53c07de98e4c \
download || dienow

URL=http://ftp.gnu.org/gnu/gdb/gdb-7.0.tar.bz2 \
SHA1=8aed621b7ddb8c82b6ff213b56c028787db90582 \
download || dienow

URL=http://repo.or.cz/w/qi-bootmenu.git/snapshot/ae9e0e4ffed61617f53fc625575464cb7e3103f1.tar.gz \
SHA1= \
RENAME="s/(.*)/qi-bootmenu-\1/" \
download || dienow

echo === Got all source.

cleanup_oldfiles
blank_tempdir "$WORK"

# Set color back to normal.
echo -ne "\e[0m"
