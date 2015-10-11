#!/bin/bash
export LDFLAGS="-static-libgcc $PREFIX/lib/libgfortran.a $PREFIX/lib/libquadmath.a"

# Configure build
chmod u+x configure
./configure --prefix=$PREFIX

# Build and install.
make -j$CPU_COUNT
chmod -R u+x bin
make install

