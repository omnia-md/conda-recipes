#!/bin/bash
export LDFLAGS="-static-libgcc \
   $(gfortran -print-file-name=libgfortran.a) \
   $(gfortran -print-file-name=libquadmath.a)"

# Configure build
chmod u+x configure
./configure --prefix=$PREFIX

# Build and install.
make -j$CPU_COUNT
chmod -R u+x bin
make install

