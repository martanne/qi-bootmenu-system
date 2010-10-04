setupfor aboriginal

./download.sh || dienow 

# first build a simple cross compiler for the host to build the 
# executables

./simple-cross-compiler.sh "`uname -m`" || dienow 

# then build a simple cross compiler for the target which is 
# needed to build the libraries

./simple-cross-compiler.sh "$ARCH" || dienow 

# and finally build a more advanced cross compiler which for
# portability is statically linked agains the host uClibc

CROSS_HOST_ARCH=`uname -m` ./cross-compiler.sh "$ARCH" || dienow

cp build/cross-compiler-$ARCH.tar.bz2 "$TOP" &&
tar -C "$TOP" -xjf build/cross-compiler-$ARCH.tar.bz2 || dienow

export PATH="$PATH:$TOP/cross-compiler-$ARCH/bin"

cleanup aboriginal
