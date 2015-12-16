#!/bin/sh
./configure --prefix=$PREFIX
make install
mkdir -p $PREFIX/lib/ccache/bin
ln -sf $PREFIX/bin/ccache $PREFIX/lib/ccache/bin/cc
ln -sf $PREFIX/bin/ccache $PREFIX/lib/ccache/bin/cpp
ln -sf $PREFIX/bin/ccache $PREFIX/lib/ccache/bin/c++
ln -sf $PREFIX/bin/ccache $PREFIX/lib/ccache/bin/gcc
ln -sf $PREFIX/bin/ccache $PREFIX/lib/ccache/bin/g++
ln -sf $PREFIX/bin/ccache $PREFIX/lib/ccache/bin/clang
ln -sf $PREFIX/bin/ccache $PREFIX/lib/ccache/bin/clang++
