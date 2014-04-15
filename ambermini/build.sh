#!/bin/bash

export CFLAGS="-I$PREFIX/include $CFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

# Configure build
chmod u+x configure
./configure --prefix=$PREFIX

# Build and install.
make
chmod -R u+x bin
make install

