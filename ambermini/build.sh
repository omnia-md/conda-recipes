#!/bin/bash

# Required for cbio cluster for some stupid reason.
#export LD_LIBRARY_PATH="/opt/gnu/gcc/4.8.1/lib64:/opt/gnu/gcc/4.8.1/lib:/opt/gnu/gmp/lib:/opt/gnu/mpc/lib:/opt/gnu/mpfr/lib"

export CUSTOMBUILDFLAGS="-static-libgfortran /usr/local/Cellar/gcc/4.9.2_1/lib/gcc/4.9/libquadmath.a \
	  -static-libgcc -lgfortran"

export CFLAGS="-I$PREFIX/include $CFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

# Configure build
chmod u+x configure
./configure --prefix=$PREFIX

# Build and install.
make
chmod -R u+x bin
make install

