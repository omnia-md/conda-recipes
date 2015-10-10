#!/bin/bash
rm UTIL/second.f
make -f $RECIPE_DIR/Makefile -r -j$CPU_COUNT libarpack.so
cp libarpack.so $PREFIX/lib/

