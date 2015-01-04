#!/bin/bash

export CFLAGS="-I$PREFIX/include $CFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

# Build and install.

chmod +x configure 
configure
make
cp packmol ${PREFIX}/bin/
