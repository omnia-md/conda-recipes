#!/bin/bash
if [ "$(uname)" == "Darwin" ]; then
    export ORIG_DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH
    export DYLD_LIBRARY_PATH=$PREFIX/lib:$DYLD_LIBRARY_PATH
    ./configure --with-netcdf=$PREFIX gnu
    export DYLD_LIBRARY_PATH=$ORIG_DYLD_LIBRARY_PATH
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    export ORIG_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
    ./configure -openblas --with-netcdf=$PREFIX gnu
    export LD_LIBRARY_PATH=$ORIG_LD_LIBRARY_PATH
fi

make -j$CPU_COUNT install
cp -R bin/* $PREFIX/bin/
