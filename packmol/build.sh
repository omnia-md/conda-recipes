#!/bin/bash

export CFLAGS="-I$PREFIX/include $CFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

# Fix broken Makefile.default

sed -e s_/usr/bin/gfortran_AUTO_ Makefile > Makefile.default

# Build and install.

chmod +x configure
./configure
make parallel
cp packmol ${PREFIX}/bin/
