#!/bin/bash

# boost expects to find python headers in $PREFIX/include/pythonX.Y
# but on python3, they're often in $PREFIX/include/pythonX.Ym
# so we make a soft link if the "m" include directory exists
# and the other doesn't.

# (This only effects the miniconda _build env, so it doesn't mess
# with any user's actual environment)
PY_INCLUDE="${INCLUDE_PATH}/python${PY_VER}"
if [[ ( ! -d "${PY_INCLUDE}" ) && ( -d "${PY_INCLUDE}m" ) ]]; then
    ln -s "${PY_INCLUDE}m" "${PY_INCLUDE}"
fi

./bootstrap.sh install --prefix=$PREFIX
./b2 -j4 install
