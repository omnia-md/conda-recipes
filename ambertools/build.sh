#!/bin/bash

export CFLAGS="-I$PREFIX/include $CFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

# Must set AMBERHOME (which becomes ANACONDA_ROOT) to base directory for initial compilation.
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

# Patch the code to change AMBERHOME.
#grep -rl AMBERHOME --include \*.c --include \*.py . | xargs sed -i -e 's/AMBERHOME/ANACONDA/g'

# Build and install.
make install

# Copy installation files into $PREFIX.
cp -r bin $PREFIX
cp -r lib $PREFIX
cp -r dat $PREFIX
