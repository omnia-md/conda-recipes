#!/bin/bash

CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=$PREFIX"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # setting the rpath so that libOpenMMPME.so finds the right libfftw3
    CMAKE_FLAGS+=" -DCMAKE_INSTALL_RPATH=.."
    CMAKE_FLAGS+=" -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
    CMAKE_FLAGS+=" -DOPENCL_INCLUDE_DIR=/usr/local/cuda-6.5/include" # CUDA 6.5
    CMAKE_FLAGS+=" -DOPENCL_LIBRARY=/usr/local/cuda-6.5/lib64/libOpenCL.so" # CUDA 6.5
    CMAKE_FLAGS+=" -DCUDA_CUDART_LIBRARY=/usr/local/cuda-6.5/lib64/libcudart.so"
    CMAKE_FLAGS+=" -DCUDA_NVCC_EXECUTABLE=/usr/local/cuda-6.5/bin/nvcc"
    CMAKE_FLAGS+=" -DCUDA_TOOLKIT_INCLUDE=/usr/local/cuda-6.5/include"
    CMAKE_FLAGS+=" -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-6.5"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    CMAKE_FLAGS+=" -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
    CMAKE_FLAGS+=" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9"
    CMAKE_FLAGS+=" -DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk"
    CMAKE_FLAGS+=" -DOPENMM_BUILD_OPENCL_LIB=OFF -DOPENMM_BUILD_DRUDE_OPENCL_LIB=OFF -DOPENMM_BUILD_RPMD_OPENCL_LIB=OFF -DOPENMM_BUILD_OPENCL_TESTS=FALSE -DOPENMM_BUILD_OPENCL_DOUBLE_PRECISION_TESTS=FALSE" # Don't build OpenCL on OS X
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

# TODO: What do we do about other dependencies, such as pdflatex and doxygen?
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    #
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # LaTeX
    export PATH=${PATH}:/usr/texbin/
fi


# Install dependencies for building docs.
pip install sphinxcontrib-bibtex

# Build in subdirectory.
mkdir build
cd build
cmake .. $CMAKE_FLAGS
make -j16 all DoxygenApiDocs sphinxpdf # build docs as well
make install

# Run C tests.
# Exclude OpenCL tests because @peastman suspects mesa on travis implementation is broken.
# @jchodera and @pgrinaway suspect travis is working, but AMD OpenCL tests are actually failing due to a bug.
#ctest -j2 -V -E "[A-Za-z]+OpenCL[A-Za-z]+"

# Install Python wrappers.
export OPENMM_INCLUDE_PATH=$PREFIX/include
export OPENMM_LIB_PATH=$PREFIX/lib
cd python
$PYTHON setup.py install
cd ..

# Remove one random file
#rm $PREFIX/bin/TestReferenceHarmonicBondForce

# Copy all tests to bin directory so they will be distributed with install package.
#cp `find . -name "Test*" -type f -maxdepth 1` $PREFIX/bin

