if [[ `uname` == 'Darwin' ]]; then
    DYLD_LIBRARY_PATH=$PREFIX/lib make FC=gfortran DYNAMIC_ARCH=1 BINARY=${ARCH} NO_LAPACK=0 NO_AFFINITY=1 NUM_THREADS=1 -j${CPU_COUNT}
    make install PREFIX=$PREFIX

    # Make sure the linked gfortran libraries are searched for on the RPATH.
    GFORTRAN_LIB=$(python -c "from os.path import realpath; print(realpath(\"$(gfortran -print-file-name=libgfortran.3.dylib)\"))")
    GCC_LIB=$(python -c "from os.path import realpath; print(realpath(\"$(gfortran -print-file-name=libgcc_s.1.dylib)\"))")
    QUADMATH_LIB=$(python -c "from os.path import realpath; print(realpath(\"$(gfortran -print-file-name=libquadmath.0.dylib)\"))")
    install_name_tool -change $GFORTRAN_LIB @rpath/libgfortran.3.dylib $PREFIX/lib/libopenblas.dylib
    install_name_tool -change $GCC_LIB @rpath/libgcc_s.1.dylib $PREFIX/lib/libopenblas.dylib
    install_name_tool -change $QUADMATH_LIB @rpath/libquadmath.0.dylib $PREFIX/lib/libopenblas.dylib
else
    exit 1
fi
