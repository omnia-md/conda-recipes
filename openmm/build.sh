#!/bin/bash

CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=$PREFIX"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # setting the rpath so that libOpenMMPME.so finds the right libfftw3
    CMAKE_FLAGS+=" -DCMAKE_INSTALL_RPATH=.."
    CMAKE_FLAGS+=" -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
    CMAKE_FLAGS+=" -DOPENCL_INCLUDE_DIR=/usr/local/cuda-6.0/include"
    CMAKE_FLAGS+=" -DOPENCL_LIBRARY=/usr/local/cuda-6.0/lib64/libOpenCL.so"
    #CMAKE_FLAGS+=" -DOPENCL_LIBRARY=/opt/AMDAPP/lib/x86_64/libOpenCL.so"

elif [[ "$OSTYPE" == "darwin"* ]]; then
    export MACOSX_DEPLOYMENT_TARGET="10.9"
    CMAKE_FLAGS+=" -DOSX_DEPLOYMENT_TARGET=10.9" # builds are on OS X 10.9
    CMAKE_FLAGS+=" -DOSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk" # builds are on OS X 10.9
    CMAKE_FLAGS+=" -DCMAKE_OSX_ARCHITECTURES=x86_64" # CUDA 6.5 no longer supports 32-bit
    CMAKE_FLAGS+=" -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++" # use clang compilers
    CMAKE_FLAGS+=" -DOPENMM_BUILD_DRUDE_OPENCL_LIB=OFF" # OpenCL is only partially disabled on OS X, so turn this off manually
    CMAKE_FLAGS+=" -DOPENMM_BUILD_RPMD_OPENCL_LIB=OFF" # OpenCL is only partially disabled on OS X, so turn this off manually
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
cmake .. "${CMAKE_FLAGS}"
make -j8
make install

export LD_LIBRARY_PATH="/opt/gnu/gcc/4.8.1/lib64:/opt/gnu/gcc/4.8.1/lib:/opt/gnu/gmp/lib:/opt/gnu/mpc/lib:/opt/gnu/mpfr/lib"

export OPENMM_INCLUDE_PATH=$PREFIX/include
export OPENMM_LIB_PATH=$PREFIX/lib
cd python
#$PYTHON setup.py config --compiler=clang build --compiler=clang install
$PYTHON setup.py install
