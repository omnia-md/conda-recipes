#!/bin/bash

$PYTHON "$RECIPE_DIR/fetch_inchi.py"
$PYTHON "$RECIPE_DIR/fetch_avalontools.py"
PY_INC=`$PYTHON -c "from distutils import sysconfig; print (sysconfig.get_python_inc(0, '$PREFIX'))"`

if [[ "$OSTYPE" == "darwin"* ]]; then
    extra_flags="
    -D Boost_PYTHON_LIBRARY_RELEASE=$PREFIX/lib/libboost_python.a \
    -D Boost_PYTHON3_LIBRARY_RELEASE=$PREFIX/lib/libboost_python3.a \
    -D Boost_REGEX_LIBRARY_RELEASE=$PREFIX/lib/libboost_regex.a \
    -D Boost_SERIALIZATION_LIBRARY_RELEASE=$PREFIX/lib/libboost_serialization.a \
    -D Boost_SYSTEM_LIBRARY_RELEASE=$PREFIX/lib/libboost_system.a \
    -D Boost_THREAD_LIBRARY_RELEASE=$PREFIX/lib/libboost_thread.a"
else
    extra_flags=""
fi

cmake \
    -D RDK_INSTALL_INTREE=OFF \
    -D RDK_INSTALL_STATIC_LIBS=OFF \
    -D RDK_BUILD_INCHI_SUPPORT=ON \
    -D RDK_BUILD_AVALON_SUPPORT=ON \
    -D RDK_USE_FLEXBISON=OFF \
    -D RDK_BUILD_THREADSAFE_SSS=ON \
    -D RDK_TEST_MULTITHREADED=ON \
    -D AVALONTOOLS_DIR=$SRC_DIR/External/AvalonTools/src/SourceDistribution \
    -D CMAKE_SYSTEM_PREFIX_PATH=$PREFIX \
    -D CMAKE_INSTALL_PREFIX=$PREFIX \
    -D Python_ADDITIONAL_VERSIONS=${PY_VER} \
    -D PYTHON_EXECUTABLE=$PYTHON \
    -D PYTHON_INCLUDE_DIR=${PY_INC} \
    -D PYTHON_NUMPY_INCLUDE_PATH=$SP_DIR/numpy/core/include \
    -D BOOST_ROOT=$PREFIX -D Boost_NO_SYSTEM_PATHS=ON \
    -D CMAKE_EXE_LINKER_FLAGS_RELEASE="-lrt" \
    -D CMAKE_BUILD_TYPE=Release \
    $extra_flags \
    .

make -j$CPU_COUNT install
