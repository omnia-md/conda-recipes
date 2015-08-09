#!/bin/bash
#export LIBDIR=$PREFIX/lib
#make GLEW_DEST=$PREFIX install.all

# anaconda does not have a lib64 dir, so libs could not be found. 
# move them lib64/ to lib/
#ls $LIBRARY_PATH
#ls $PREFIX

mkdir build
cd build; cmake -DCMAKE_INSTALL_PREFIX=$PREFIX ..
make install
mv $PREFIX/lib64 $PREFIX/lib
