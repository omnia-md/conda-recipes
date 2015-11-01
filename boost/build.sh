#!/bin/bash

# boost expects to find python headers in $PREFIX/include/pythonX.Y
# but on python3, they're often in $PREFIX/include/pythonX.Ym
# so we make a soft link if the "m" include directory exists
# and the other doesn't.

# (This only effects the miniconda _build env, so it doesn't mess
# with any user's actual environment)

linking_include_m=false
linkinging_lib_m=false
linking_config_m=false

PY_INCLUDE="${PREFIX}/include/python${PY_VER}"
if [[ ( ! -d "${PY_INCLUDE}" ) && ( -d "${PY_INCLUDE}m" ) ]]; then
    linking_include_m=true
    ln -s "${PY_INCLUDE}m" "${PY_INCLUDE}"
fi

if [[ ( ! -f "${PREFIX}/lib/libpython${PY_VER}.dylib" ) && ( -f "${PREFIX}/lib/libpython${PY_VER}m.dylib"  ) ]]; then
    linkinging_lib_m=true
    ln -s  "${PREFIX}/lib/libpython${PY_VER}m.dylib" "${PREFIX}/lib/libpython${PY_VER}.dylib"
fi

PY_LIB="${PREFIX}/lib/python${PY_VER}"
if [[ ( ! -d "${PY_LIB}/config" ) && ( -d "${PY_LIB}/config-${PY_VER}m" ) ]]; then
    linking_config_m=true
    ln -s "${PY_LIB}/config-${PY_VER}m" "${PY_LIB}/config"
fi

cxxflags="-I${PREFIX}/include/"
linkflags="-L${PREFIX}/lib/"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # http://stackoverflow.com/questions/20108407/how-do-i-compile-boost-for-os-x-64b-platforms-with-stdlibc
    cxxflags="${cxxflags} -stdlib=libstdc++"
    linkflags="${linkflags} -stdlib=libstdc++"
fi

./bootstrap.sh install --prefix=$PREFIX
./b2 -j$CPU_COUNT install cxxflags="$cxxflags" linkflags="$linkflags"

if [[ linking_include_m ]]; then
    rm -f "${PY_INCLUDE}"
fi
if [[ linkinging_lib_m ]]; then
    rm -f "${PREFIX}/lib/libpython${PY_VER}.dylib"
fi

if [[ linking_config_m ]]; then
    rm -f "${PY_LIB}/config"
fi

