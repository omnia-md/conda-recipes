#!/bin/bash
export LDFLAGS="-static-libgcc -lm \
   $(gfortran -print-file-name=libgfortran.a) \
   $(gfortran -print-file-name=libquadmath.a)"

# Configure build
chmod u+x configure
./configure --prefix=$PREFIX

# we deal with lgfortran through ldflags. don't want it
# on config.h, where it overrides and leads to dynamic
# linking on linux
if [ "$(uname)" == "Darwin" ]; then
    sed -i '' 's/-lgfortran//g' config.h
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    sed -i 's/-lgfortran//g' config.h
fi

# Build and install.
make -j$CPU_COUNT
chmod -R u+x bin
make install
