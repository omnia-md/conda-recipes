#!/usr/bin/env bash

set -x -e

export LIBRARY_PATH="${PREFIX}/lib"
export INCLUDE_PATH="${PREFIX}/include"

#python setup.py config --with-includepath="${PREFIX}/include"
python setup.py build_ext -I "${PREFIX}/include"
python setup.py install --single-version-externally-managed --record record.txt
