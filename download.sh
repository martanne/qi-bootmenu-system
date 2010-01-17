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

URL='http://git.openmoko.org/?p=kernel.git;a=snapshot;h=06ac2c30542ba47bfe0ffc15b7868bb049bec053;sf=tgz' \
SHA1= \
RENAME="s/.*h=(.*);.*/kernel-\1.tar.gz/" \
download || dienow

URL=http://www.uclibc.org/downloads/uClibc-0.9.30.2.tar.bz2 \
SHA1=a956b1c37e3163c961dad7fdf96b6d4c7e176d1f \
download || dienow

URL=http://www.busybox.net/downloads/busybox-1.15.3.tar.bz2 \
SHA1=a05a692840ba1cd2bbe21af196f28809694c47e4 \
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

URL=http://matt.ucc.asn.au/dropbear/releases/dropbear-0.52.tar.bz2 \
SHA1=8c1745a9b64ffae79f28e25c6fe9a8b96cac86d8 \
download || dienow

URL=http://downloads.sourceforge.net/project/strace/strace/4.5.18/strace-4.5.18.tar.bz2 \
SHA1=50081a7201dc240299396f088abe53c07de98e4c \
download || dienow

URL=http://ftp.gnu.org/gnu/gdb/gdb-7.0.tar.bz2 \
SHA1=8aed621b7ddb8c82b6ff213b56c028787db90582 \
download || dienow

URL=http://repo.or.cz/w/qi-bootmenu.git/snapshot/114898cf61ad635cb8e9f7f60d304791d3350701.tar.gz \
SHA1= \
RENAME="s/(.*)/qi-bootmenu-\1/" \
download || dienow

URL='http://git.openmoko.org/?p=qi.git;a=snapshot;h=c38b062a609f1442e6a9e13005cfbdfd59a5ac0d;sf=tgz' \
SHA1= \
RENAME="s/.*h=(.*);.*/qi-bootloader-\1.tar.gz/" \
download || dienow

echo === Got all source.

cleanup_oldfiles
blank_tempdir "$WORK"

# Set color back to normal.
echo -ne "\e[0m"
