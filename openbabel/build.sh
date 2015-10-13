#!/bin/bash
if [ `uname` == Darwin ]; then
    SO_EXT='dylib'
else
    SO_EXT='so'
fi

wget http://bitbucket.org/eigen/eigen/get/3.2.6.tar.bz2
tar -xjf 3.2.6.tar.bz2


cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DPYTHON_LIBRARY=$PREFIX/lib/libpython${PY_VER}.${SO_EXT} \
      -DPYTHON_EXECUTABLE=$PYTHON \
      -DPYTHON_INCLUDE_DIR=$PREFIX/include/python${PY_VER} \
      -DPYTHON_BINDINGS=ON \
      -DEIGEN3_INCLUDE_DIR=eigen-eigen-c58038c56923 \
      -DRUN_SWIG=ON

make -j${CPU_COUNT}
make install

cd scripts/python
python setup.py install
