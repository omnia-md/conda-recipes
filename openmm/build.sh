#!/bin/bash

CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=$PREFIX"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if [ $(command -v nvcc) ]; then
        # have nvcc
        if [ "$(uname -m | grep '64')" != "" ]; then
            UBUNTU_NVIDIA_DIR=`sed -n '/^\/usr\/lib\//{p;q}' /etc/ld.so.conf.d/x86_64-linux-gnu_GL.conf`
        else
            UBUNTU_NVIDIA_DIR=`sed -n '/^\/usr\/lib\//{p;q}' /etc/ld.so.conf.d/i386-linux-gnu_GL.conf`
        fi
        CMAKE_FLAGS+=" -DCUDA_CUDA_LIBRARY=$UBUNTU_NVIDIA_DIR/libcuda.so"
    fi
    # setting the rpath so that libOpenMMPME.so finds the right libfftw3
    CMAKE_FLAGS+=" -DCMAKE_INSTALL_RPATH=.."

elif [[ "$OSTYPE" == "darwin"* ]]; then
    export MACOSX_DEPLOYMENT_TARGET="10.7"
    CMAKE_FLAGS+=" -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
fi

# Set location for FFTW3 on both linux and mac
CMAKE_FLAGS+=" -DFFTW_INCLUDES=$PREFIX/include"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    CMAKE_FLAGS+=" -DFFTW_LIBRARY=$PREFIX/lib/libfftw3f.so"
    CMAKE_FLAGS+=" -DFFTW_THREADS_LIBRARY=$PREFIX/lib/libfftw3f_threads.so"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    CMAKE_FLAGS+=" -DFFTW_LIBRARY=$PREFIX/lib/libfftw3f.dylib"
    CMAKE_FLAGS+=" -DFFTW_THREADS_LIBRARY=$PREFIX/lib/libfftw3f_threads.dylib"
fi


mkdir build
cd build
cmake .. $CMAKE_FLAGS
make -j4
make install

export OPENMM_INCLUDE_PATH=$PREFIX/include
export OPENMM_LIB_PATH=$PREFIX/lib
cd python
$PYTHON setup.py install

# Remove one random file
rm $PREFIX/bin/TestReferenceHarmonicBondForce

