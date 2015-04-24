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

if [[ ( ! -f "${LIBRARY_PATH}/libpython${PY_VER}.dylib" ) && ( -f "${LIBRARY_PATH}/libpython${PY_VER}m.dylib"  ) ]]; then
    ln -s  "${LIBRARY_PATH}/libpython${PY_VER}m.dylib" "${LIBRARY_PATH}/libpython${PY_VER}.dylib"
fi

PY_LIB="${LIBRARY_PATH}/python${PY_VER}"
if [[ ( ! -d "${PY_LIB}/config" ) && ( -d "${PY_LIB}/config-${PY_VER}m" ) ]]; then
    ln -s "${PY_LIB}/config-${PY_VER}m" "${PY_LIB}/config"
fi

cxxflags="-I${INCLUDE_PATH}"
linkflags="-L${LIBRARY_PATH}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # http://stackoverflow.com/questions/20108407/how-do-i-compile-boost-for-os-x-64b-platforms-with-stdlibc
    cxxflags="${cxxflags} -stdlib=libstdc++"
    linkflags="${linkflags} stdlib=libstdc++"
fi

./bootstrap.sh install --prefix=$PREFIX
./b2 -j1 install cxxflags=\'$cxxflags\' linkflags=\'$linkflags\'
