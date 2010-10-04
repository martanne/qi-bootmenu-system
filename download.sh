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

URL='http://git.openmoko.org/?p=kernel.git;a=snapshot;h=e4182f3551f1b8e8f8bd07a2d68e49a0ec4cd04a;sf=tgz' \
SHA1= \
RENAME="s/.*h=(.*);.*/kernel-\1.tar.gz/" \
download || dienow

URL=http://www.uclibc.org/downloads/uClibc-0.9.31.tar.bz2 \
SHA1=f25f70534594dffdb6b9008799a1532271178338 \
download || dienow

URL=http://busybox.net/downloads/busybox-1.17.1.tar.bz2 \
SHA1=691f44088c3327c957158443e813ec7346e99df6 \
download || dienow

URL=http://kernel.org/pub/linux/utils/kernel/kexec/kexec-tools-2.0.2.tar.bz2 \
SHA1=cc0fcb1c258d46ac21cb064b73c19cee458f4ee7 \
download || dienow

URL=http://www.zlib.net/zlib-1.2.5.tar.bz2 \
SHA1=543fa9abff0442edca308772d6cef85557677e02 \
download || dienow

URL=http://downloads.sourceforge.net/project/libpng/01-libpng-master/1.4.3/libpng-1.4.3.tar.bz2 \
SHA1=82eda95439daaef6ed564b1532cf805b01759557 \
download || dienow

URL=http://github.com/kergoth/tslib/tarball/8c04294943437e4831ee33f67847b9c862620eb9 \
SHA1=23b13aa7aa4abd24ba0acb2bd8d14044f06487b1 \
RENAME="s/(.*)/tslib-\1.tar.gz/" \
download || dienow

URL=http://download.savannah.gnu.org/releases/freetype/freetype-2.4.2.tar.bz2 \
SHA1=cc257ceda2950b8c80950d780ccf3ce665a815d1 \
download || dienow

URL=http://download.enlightenment.org/releases/eina-1.0.0.beta.tar.bz2 \
SHA1=a02474ae627f3a20cae5439f39c631c0447ae7d5 \
download || dienow

URL=http://download.enlightenment.org/releases/evas-1.0.0.beta.tar.bz2 \
SHA1=0bdef4fdeb3a0a787771f8ac044e2354a1937214 \
download || dienow

URL=http://download.enlightenment.org/releases/ecore-1.0.0.beta.tar.bz2 \
SHA1=57d9ed899f0581504d64583708de58da076d7d64 \
download || dienow

URL=http://matt.ucc.asn.au/dropbear/releases/dropbear-0.52.tar.bz2 \
SHA1=8c1745a9b64ffae79f28e25c6fe9a8b96cac86d8 \
download || dienow

URL=http://downloads.sourceforge.net/project/strace/strace/4.5.19/strace-4.5.19.tar.bz2 \
SHA1=5554c2fd8ffae5c1e2b289b2024aa85a0889c989 \
download || dienow

URL=http://ftp.gnu.org/gnu/gdb/gdb-7.0.tar.bz2 \
SHA1=8aed621b7ddb8c82b6ff213b56c028787db90582 \
download || dienow

#SHA1=e57005075db77e21aab0ba509f4f0fe4a48283d6 \
URL=http://www.brain-dump.org/projects/qi-bootmenu/qi-bootmenu-0.1.tar.gz \
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
