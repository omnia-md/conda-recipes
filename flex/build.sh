#!/bin/bash
./configure --prefix="$PREFIX" --disable-shared --disable-dependency-tracking
make
make install
