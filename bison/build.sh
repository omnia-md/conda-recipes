#!/bin/bash

exit 1
./configure --prefix="$PREFIX"
make
make install

