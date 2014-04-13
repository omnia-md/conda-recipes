#!/bin/bash

export CFLAGS="-I$PREFIX/include $CFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

# Must set AMBERHOME to base directory.
export AMBERHOME="$SRC_DIR"

# Update with latest patches.
./update_amber --update

# Configure AmberTools compilation.
# TODO: Allow NetCDF in future.
echo y | ./configure \
    -noX11 \
    -nobintraj \
    -nosse \
    -noamber \
    -norism \
    -nofftw3 \
    gnu

# Build and install.
make install

# Copy files into bin and lib.
cp -r bin $PREFIX
cp -r lib $PREFIX
