#!/bin/bash

export BLAS_LAPACK_LIB_PATHS=$PREFIX/lib
if [[ "$OSTYPE" == "darwin"* ]]; then
    export BLAS_LAPACK_LIBS=openblas:gfortran:quadmath
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    export BLAS_LAPACK_LIBS=openblas:gfortran
fi

$PYTHON setup.py install

