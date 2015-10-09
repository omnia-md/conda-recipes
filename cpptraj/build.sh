#!/bin/bash
if [ "$(uname)" == "Darwin" ]; then
    # OS X
    export ORIG_DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH
    export DYLD_LIBRARY_PATH=$PREFIX/lib:$DYLD_LIBRARY_PATH
    ./configure -fftw3 --with-netcdf=$PREFIX clang
    export DYLD_LIBRARY_PATH=$ORIG_DYLD_LIBRARY_PATH
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under Linux platform
    ./configure -fftw3 --with-netcdf=$PREFIX gnu
fi

make -j$CPU_COUNT install
cp -R bin/* $PREFIX/bin/
