#!/bin/bash

export CFLAGS="-I$PREFIX/include $CFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

# Configure build
./configure --prefix=$PREFIX

# Build and install.
make install
